import SwiftUI

// MARK: - Scenario Lesson View

struct ScenarioLessonViewImpl: View {
    let scenario: ScenarioLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    var finalCompleteLabel: String = "COMPLETE SCENARIO"
    var onComplete: (() -> Void)? = nil

    @State private var currentStepIndex = 0
    @State private var selectedArgument: String?
    @State private var showCompletion = false
    @State private var isCompletingStep = false

    private var currentStep: ScenarioStep {
        scenario.steps[currentStepIndex]
    }

    private var isLastStep: Bool {
        currentStepIndex == scenario.steps.count - 1
    }

    private var argumentChoices: [String] {
        meaningfulArgumentChoices(options: currentStep.options, answer: currentStep.answer)
    }

    private var automaticArgument: String? {
        defaultArgument(for: currentStep.answer, visibleChoices: argumentChoices)
    }

    private var terminalInput: String {
        terminalCommandLine(
            command: vm.userInput,
            argument: selectedArgument,
            fallbackArgument: automaticArgument
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            MissionMemoPanel(
                setup: scenario.setup,
                goal: scenario.goal,
                currentStep: currentStepIndex + 1,
                totalSteps: scenario.steps.count
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ProblemBriefPanel(
                        title: "手順",
                        subtitle: "STEP \(currentStepIndex + 1) / \(scenario.steps.count)",
                        text: currentStep.prompt,
                        detail: ""
                    )

                    TerminalPanel(
                        input: terminalInput,
                        output: vm.terminalOutput,
                        state: vm.currentLessonState,
                        successMessage: isLastStep ? scenario.finaleMessage : "STEP \(currentStepIndex + 1) COMPLETE",
                        minHeight: 112
                    )

                    WordBankPanel(
                        arguments: argumentChoices,
                        selectedArgument: $selectedArgument,
                        options: currentStep.options,
                        selectedCommand: vm.userInput,
                        areArgumentsDisabled: vm.currentLessonState != .waiting || isCompletingStep,
                        areCommandsDisabled: vm.currentLessonState != .waiting || vm.isTyping || isCompletingStep
                    ) { command in
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        vm.selectCommandText(command)
                    }

                    ActionBar(
                        canRun: (argumentChoices.isEmpty || selectedArgument != nil) && !vm.userInput.isEmpty && !vm.isTyping && vm.currentLessonState == .waiting && !isCompletingStep,
                        state: vm.currentLessonState,
                        completeLabel: isLastStep ? finalCompleteLabel : "NEXT STEP",
                        runAction: {
                            let impact = UIImpactFeedbackGenerator(style: .heavy)
                            impact.impactOccurred()
                            vm.executeScenarioStep(currentStep, enteredCommand: terminalInput)
                        },
                        retryAction: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            selectedArgument = nil
                            vm.retry()
                        },
                        completeAction: {
                            guard !isCompletingStep else { return }
                            isCompletingStep = true
                            let impact = UINotificationFeedbackGenerator()
                            impact.notificationOccurred(.success)

                            if isLastStep {
                                showCompletion = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                                    if let onComplete {
                                        onComplete()
                                    } else {
                                        vm.completeLesson(lesson)
                                        vm.goBack()
                                    }
                                }
                            } else {
                                withAnimation(.spring(response: 0.36, dampingFraction: 0.78)) {
                                    currentStepIndex += 1
                                    selectedArgument = nil
                                    vm.nextStep()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                                    isCompletingStep = false
                                }
                            }
                        }
                    )
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.bottom, 12)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            vm.resetLesson()
            currentStepIndex = 0
            selectedArgument = nil
            isCompletingStep = false
        }
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
    }
}

struct MissionMemoPanel: View {
    let setup: String
    let goal: String
    let currentStep: Int
    let totalSteps: Int

    private var situationText: String {
        setup
            .components(separatedBy: "\n\n")
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? setup
    }

    var body: some View {
        ShellPanel(borderOpacity: 0.28, cornerRadius: TerminalTheme.buttonRadius) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text("MISSION MEMO")
                        .shellFont(.caption, weight: .bold)
                        .foregroundColor(TerminalTheme.bluePrimary)

                    Spacer(minLength: 8)

                    Text("STEP \(currentStep)/\(totalSteps)")
                        .shellFont(.caption2, weight: .bold)
                        .foregroundColor(TerminalTheme.greenPrimary)
                }

                VStack(alignment: .leading, spacing: 5) {
                    MemoLine(label: "現状", text: situationText, lineLimit: 2)
                    MemoLine(label: "目的", text: goal, lineLimit: 2)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(height: 144)
    }
}

private struct MemoLine: View {
    let label: String
    let text: String
    let lineLimit: Int

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .shellFont(.caption2, weight: .bold)
                .foregroundColor(TerminalTheme.textTertiary)
                .frame(width: 34, alignment: .leading)

            Text(text)
                .shellFont(.caption)
                .foregroundColor(TerminalTheme.textSecondary)
                .lineLimit(lineLimit)
                .lineSpacing(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Quiz Lesson View

struct QuizLessonViewImpl: View {
    let quiz: QuizLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    var finalCompleteLabel: String = "COMPLETE QUIZ"
    var onComplete: (() -> Void)? = nil

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var correctQuestionIndexes: Set<Int> = []
    @State private var questionOrder: [Int] = []
    @State private var choiceOrders: [Int: [Int]] = [:]
    @State private var showCompletion = false
    @State private var isAdvancing = false

    private var currentQuestion: QuizQuestion {
        quiz.questions[currentQuestionOriginalIndex]
    }

    private var currentQuestionOriginalIndex: Int {
        guard questionOrder.indices.contains(currentQuestionIndex) else {
            return min(currentQuestionIndex, max(quiz.questions.count - 1, 0))
        }
        return questionOrder[currentQuestionIndex]
    }

    private var currentChoiceOrder: [Int] {
        let fallback = Array(currentQuestion.choices.indices)
        guard let order = choiceOrders[currentQuestionOriginalIndex], order.count == currentQuestion.choices.count else {
            return fallback
        }
        return order
    }

    private var isLastQuestion: Bool {
        currentQuestionIndex == questionOrder.count - 1
    }

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    private var isCorrect: Bool {
        selectedAnswerIndex == currentQuestion.correctIndex
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ShellPanel {
                VStack(alignment: .leading, spacing: 10) {
                    ShellSectionTitle(title: "問題")
                    Text(currentQuestion.question)
                        .shellFont(.body, weight: .semibold)
                        .foregroundColor(TerminalTheme.textPrimary)
                        .lineLimit(5)
                        .lineSpacing(3)
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(height: 124)

            Spacer(minLength: 0)

            ShellPanel(borderOpacity: 0.26) {
                VStack(alignment: .leading, spacing: 10) {
                    ShellSectionTitle(title: "語群")

                    VStack(spacing: 8) {
                        ForEach(Array(currentChoiceOrder.enumerated()), id: \.element) { displayIndex, originalChoiceIndex in
                            Button {
                                guard !isAnswered, !isAdvancing else { return }
                                selectedAnswerIndex = originalChoiceIndex

                                if originalChoiceIndex == currentQuestion.correctIndex {
                                    correctQuestionIndexes.insert(currentQuestionOriginalIndex)
                                }

                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            } label: {
                                HStack(spacing: 10) {
                                    Text(choicePrefix(for: displayIndex))
                                        .shellFont(.caption, weight: .bold)
                                        .foregroundColor(TerminalTheme.greenPrimary)
                                        .frame(width: 26, alignment: .leading)

                                    Text(currentQuestion.choices[originalChoiceIndex])
                                        .shellFont(.subheadline)
                                        .foregroundColor(TerminalTheme.textPrimary)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)

                                    Spacer(minLength: 8)

                                    if isAnswered {
                                        Text(resultLabel(for: originalChoiceIndex))
                                            .shellFont(.caption2, weight: .bold)
                                            .foregroundColor(resultColor(for: originalChoiceIndex))
                                    }
                                }
                            }
                            .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedAnswerIndex == originalChoiceIndex || (isAnswered && originalChoiceIndex == currentQuestion.correctIndex)))
                            .frame(height: 58)
                            .disabled(isAnswered || isAdvancing)
                        }
                    }
                    .id(currentQuestionOriginalIndex)

                    QuizFeedbackSlot(
                        isAnswered: isAnswered,
                        isCorrect: isCorrect,
                        explanation: currentQuestion.explanation
                    )
                }
            }

            QuizActionSlot(
                isAnswered: isAnswered,
                isCorrect: isCorrect,
                isLastQuestion: isLastQuestion,
                isAdvancing: isAdvancing,
                finalCompleteLabel: finalCompleteLabel,
                nextAction: advanceAfterCorrectAnswer,
                retryAction: retryCurrentQuestion
            )
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: currentQuestionOriginalIndex) {
            selectedAnswerIndex = nil
            isAdvancing = false
        }
        .onAppear {
            vm.resetLesson()
            resetQuizSession()
        }
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
    }

    private func choicePrefix(for index: Int) -> String {
        guard let scalar = UnicodeScalar(65 + index) else {
            return "\(index + 1)"
        }
        return String(Character(scalar))
    }

    private func resultLabel(for index: Int) -> String {
        if index == currentQuestion.correctIndex {
            return "OK"
        }
        if selectedAnswerIndex == index {
            return "MISS"
        }
        return ""
    }

    private func resultColor(for index: Int) -> Color {
        index == currentQuestion.correctIndex ? TerminalTheme.greenPrimary : TerminalTheme.textTertiary
    }

    private func resetQuizSession() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        correctQuestionIndexes = []
        showCompletion = false
        isAdvancing = false

        let indices = Array(quiz.questions.indices)
        questionOrder = indices.shuffled()
        choiceOrders = Dictionary(
            uniqueKeysWithValues: indices.map { index in
                (index, Array(quiz.questions[index].choices.indices).shuffled())
            }
        )
    }

    private func retryCurrentQuestion() {
        guard !isAdvancing else { return }
        selectedAnswerIndex = nil
        choiceOrders[currentQuestionOriginalIndex] = Array(currentQuestion.choices.indices).shuffled()
    }

    private func advanceAfterCorrectAnswer() {
        guard isCorrect, !isAdvancing else { return }
        isAdvancing = true

        if isLastQuestion {
            showCompletion = true
            vm.addXP(correctQuestionIndexes.count * 50)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                if let onComplete {
                    onComplete()
                } else {
                    vm.completeLesson(lesson)
                    vm.goBack()
                }
            }
        } else {
            selectedAnswerIndex = nil
            currentQuestionIndex += 1

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                isAdvancing = false
            }
        }
    }
}

struct QuizFeedbackSlot: View {
    let isAnswered: Bool
    let isCorrect: Bool
    let explanation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(TerminalTheme.borderColor)
                .frame(height: 1)
                .opacity(0.72)

            VStack(alignment: .leading, spacing: 7) {
                ShellSectionTitle(title: isCorrect ? "OK" : "REVIEW")

                Text(explanation)
                    .shellFont(.caption)
                    .foregroundColor(TerminalTheme.textSecondary)
                    .lineLimit(4)
                    .lineSpacing(3)
            }
            .opacity(isAnswered ? 1 : 0)
            .animation(.easeOut(duration: 0.16), value: isAnswered)
        }
        .frame(height: 116, alignment: .topLeading)
        .accessibilityHidden(!isAnswered)
    }
}

struct QuizActionSlot: View {
    let isAnswered: Bool
    let isCorrect: Bool
    let isLastQuestion: Bool
    let isAdvancing: Bool
    let finalCompleteLabel: String
    let nextAction: () -> Void
    let retryAction: () -> Void

    var body: some View {
        ZStack {
            if isAnswered && isCorrect {
                Button(isLastQuestion ? finalCompleteLabel : "NEXT QUESTION") {
                    nextAction()
                }
                .buttonStyle(ShellButtonStyle(kind: .filled))
                .disabled(isAdvancing)
                .opacity(isAdvancing ? 0.48 : 1)
            } else if isAnswered {
                Button("TRY AGAIN") {
                    retryAction()
                }
                .buttonStyle(ShellButtonStyle(kind: .outline))
                .disabled(isAdvancing)
            } else {
                Color.clear
            }
        }
        .frame(height: 50)
        .animation(.easeOut(duration: 0.16), value: isAnswered)
        .animation(.easeOut(duration: 0.16), value: isCorrect)
    }
}
