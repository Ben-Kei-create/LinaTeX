import SwiftUI

// MARK: - Scenario Lesson View

struct ScenarioLessonViewImpl: View {
    let scenario: ScenarioLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    var finalCompleteLabel: String = "完了"
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
        VStack(alignment: .leading, spacing: 14) {
            ProblemInstructionCard(
                title: "状況",
                icon: "flag.fill",
                color: course.level.modernColor,
                badge: "STEP \(currentStepIndex + 1) / \(scenario.steps.count)"
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(scenario.setup)
                        .font(ModernFont.bodyMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineSpacing(5)

                    Divider()

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "target")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(ModernTheme.success)
                            .padding(.top, 2)
                        Text(scenario.goal)
                            .font(ModernFont.bodySmall)
                            .foregroundColor(ModernTheme.textSecondary)
                            .lineSpacing(4)
                    }
                }
            }

            ProblemInstructionCard(
                title: "問題",
                icon: "questionmark.circle.fill",
                color: ModernTheme.secondary
            ) {
                Text(currentStep.prompt)
                    .font(ModernFont.bodyLarge)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineSpacing(5)
            }

            TerminalPanel(
                input: terminalInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                minHeight: 112
            )

            CommandChoiceSection(
                title: "選択肢",
                options: currentStep.options,
                selectedCommand: vm.userInput,
                accentColor: course.level.modernColor,
                isDisabled: vm.currentLessonState != .waiting || vm.isTyping || isCompletingStep
            ) { option in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                vm.selectCommandText(option.command)
            }

            if !argumentChoices.isEmpty {
                ArgumentChoiceSection(
                    title: "対象",
                    arguments: argumentChoices,
                    selectedArgument: selectedArgument,
                    accentColor: course.level.modernColor,
                    isDisabled: vm.currentLessonState != .waiting || isCompletingStep
                ) { argument in
                    selectedArgument = argument
                }
            }

            HStack(spacing: 10) {
                if vm.currentLessonState == .wrong {
                    PrimaryActionButton(
                        title: "もう一度",
                        icon: "arrow.counterclockwise",
                        style: .secondary
                    ) {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        selectedArgument = nil
                        vm.retry()
                    }
                }

                if vm.currentLessonState == .correct {
                    PrimaryActionButton(
                        title: isLastStep ? finalCompleteLabel : "次の手順",
                        icon: isLastStep ? "checkmark.circle.fill" : "arrow.right.circle.fill",
                        style: .success
                    ) {
                        completeCurrentStep()
                    }
                    .transition(.scale.combined(with: .opacity))
                } else {
                    PrimaryActionButton(
                        title: vm.isExecuting ? "実行中..." : "実行",
                        icon: vm.isExecuting ? "hourglass" : "play.fill",
                        style: .primary,
                        color: course.level.modernColor,
                        disabled: !(argumentChoices.isEmpty || selectedArgument != nil) || vm.userInput.isEmpty || vm.isTyping || vm.currentLessonState != .waiting || isCompletingStep || vm.isExecuting
                    ) {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        vm.executeScenarioStep(currentStep, enteredCommand: terminalInput)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
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

    private func completeCurrentStep() {
        guard !isCompletingStep else { return }
        isCompletingStep = true
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)

        if isLastStep {
            showCompletion = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                vm.completeLesson(lesson)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let onComplete {
                        onComplete()
                    } else {
                        vm.goBack()
                    }
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
}

// MARK: - Quiz Lesson View

struct QuizLessonViewImpl: View {
    let quiz: QuizLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    var finalCompleteLabel: String = "完了"
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
        currentQuestionIndex == max(displayedQuestionCount - 1, 0)
    }

    private var displayedQuestionCount: Int {
        questionOrder.isEmpty ? quiz.questions.count : questionOrder.count
    }

    private var isAnswered: Bool {
        selectedAnswerIndex != nil
    }

    private var isCorrect: Bool {
        selectedAnswerIndex == currentQuestion.correctIndex
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ProblemInstructionCard(
                title: "問題",
                icon: "questionmark.circle.fill",
                color: course.level.modernColor,
                badge: "Q\(currentQuestionIndex + 1) / \(displayedQuestionCount)"
            ) {
                Text(currentQuestion.question)
                    .font(ModernFont.bodyLarge)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineSpacing(5)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("選択肢")
                    .font(ModernFont.labelMedium)
                    .foregroundColor(ModernTheme.textSecondary)

                VStack(spacing: 8) {
                    ForEach(Array(currentChoiceOrder.enumerated()), id: \.element) { displayIndex, originalChoiceIndex in
                        QuizChoiceButton(
                            prefix: choicePrefix(for: displayIndex),
                            text: currentQuestion.choices[originalChoiceIndex],
                            accentColor: course.level.modernColor,
                            isSelected: selectedAnswerIndex == originalChoiceIndex,
                            isCorrectAnswer: originalChoiceIndex == currentQuestion.correctIndex,
                            isAnswered: isAnswered,
                            isDisabled: isAnswered || isAdvancing
                        ) {
                            guard !isAnswered, !isAdvancing else { return }
                            selectedAnswerIndex = originalChoiceIndex

                            if originalChoiceIndex == currentQuestion.correctIndex {
                                correctQuestionIndexes.insert(currentQuestionOriginalIndex)
                            }

                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                        }
                    }
                }
                .id(currentQuestionOriginalIndex)
            }

            if isAnswered {
                QuizExplanationCard(
                    isCorrect: isCorrect,
                    explanation: currentQuestion.explanation
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            HStack(spacing: 10) {
                if isAnswered && !isCorrect {
                    PrimaryActionButton(
                        title: "もう一度",
                        icon: "arrow.counterclockwise",
                        style: .secondary
                    ) {
                        retryCurrentQuestion()
                    }
                    .disabled(isAdvancing)
                }

                if isAnswered && isCorrect {
                    PrimaryActionButton(
                        title: isLastQuestion ? finalCompleteLabel : "次へ",
                        icon: isLastQuestion ? "checkmark.circle.fill" : "arrow.right.circle.fill",
                        style: .success
                    ) {
                        advanceAfterCorrectAnswer()
                    }
                    .disabled(isAdvancing)
                    .opacity(isAdvancing ? 0.48 : 1)
                }
            }
            .frame(height: isAnswered ? 50 : 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 20)
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
            let baseXP = correctQuestionIndexes.count * 50
            var bonusXP = 0
            if correctQuestionIndexes.count == displayedQuestionCount {
                bonusXP = 50
            }
            vm.addXP(baseXP + bonusXP)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                vm.completeLesson(lesson)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if let onComplete {
                        onComplete()
                    } else {
                        vm.goBack()
                    }
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
