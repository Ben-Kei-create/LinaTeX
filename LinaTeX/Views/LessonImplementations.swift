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
    @State private var selectedTarget: String?
    @State private var showCompletion = false

    private var currentStep: ScenarioStep {
        scenario.steps[currentStepIndex]
    }

    private var isLastStep: Bool {
        currentStepIndex == scenario.steps.count - 1
    }

    private var requiredTarget: String? {
        expectedTargetToken(from: targetSourceText, answer: currentStep.answer)
    }

    private var targetSourceText: String {
        "\(currentStep.hint) \(scenario.setup) \(scenario.goal) \(currentStep.prompt)"
    }

    private var targetChoices: [String] {
        targetOptions(from: targetSourceText, expected: requiredTarget)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProblemBriefPanel(
                title: "手順",
                subtitle: nil,
                text: currentStep.prompt,
                detail: scenario.setup,
                hint: vm.showHint ? currentStep.hint : nil
            ) {
                withAnimation(.easeOut(duration: 0.16)) {
                    vm.showHint.toggle()
                }
            }

            TerminalPanel(
                input: vm.userInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                successMessage: isLastStep ? scenario.finaleMessage : "STEP \(currentStepIndex + 1) COMPLETE",
                minHeight: 112
            )

            Spacer(minLength: 0)

            WordBankPanel(
                targets: targetChoices,
                selectedTarget: $selectedTarget,
                options: currentStep.options,
                selectedCommand: vm.userInput,
                isDisabled: vm.currentLessonState != .waiting
            ) { option in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                vm.selectCommand(option)
            }

            ActionBar(
                canRun: (targetChoices.isEmpty || selectedTarget != nil) && !vm.userInput.isEmpty && !vm.isTyping && vm.currentLessonState == .waiting,
                state: vm.currentLessonState,
                completeLabel: isLastStep ? finalCompleteLabel : "NEXT STEP",
                runAction: {
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                    if requiredTarget == nil || selectedTarget == requiredTarget {
                        vm.executeScenarioStep(currentStep)
                    } else {
                        vm.failSelection("対象が違います: \(selectedTarget ?? "未選択")")
                    }
                },
                retryAction: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    selectedTarget = nil
                    vm.retry()
                },
                completeAction: {
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
                            selectedTarget = nil
                            vm.nextStep()
                        }
                    }
                }
            )
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .animation(.spring(response: 0.4, dampingFraction: 0.76), value: vm.currentLessonState)
        .onAppear {
            vm.resetLesson()
            currentStepIndex = 0
            selectedTarget = nil
        }
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
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
    @State private var answeredQuestions: [Int: Int] = [:]
    @State private var correctCount = 0
    @State private var showCompletion = false

    private var currentQuestion: QuizQuestion {
        quiz.questions[currentQuestionIndex]
    }

    private var isLastQuestion: Bool {
        currentQuestionIndex == quiz.questions.count - 1
    }

    private var isAnswered: Bool {
        answeredQuestions[currentQuestionIndex] != nil
    }

    private var isCorrect: Bool {
        answeredQuestions[currentQuestionIndex] == currentQuestion.correctIndex
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
            }

            if isAnswered {
                ShellPanel(borderOpacity: isCorrect ? 0.3 : 0.16) {
                    VStack(alignment: .leading, spacing: 8) {
                        ShellSectionTitle(
                            title: isCorrect ? "OK" : "REVIEW"
                        )

                        Text(currentQuestion.explanation)
                            .shellFont(.caption)
                            .foregroundColor(TerminalTheme.textSecondary)
                            .lineLimit(4)
                            .lineSpacing(3)
                    }
                }
                .transition(.opacity)
            }

            Spacer(minLength: 0)

            ShellPanel(borderOpacity: 0.26) {
                VStack(alignment: .leading, spacing: 10) {
                    ShellSectionTitle(title: "語群")

                    VStack(spacing: 8) {
                ForEach(0..<currentQuestion.choices.count, id: \.self) { index in
                    Button {
                        guard !isAnswered else { return }
                        selectedAnswerIndex = index
                        answeredQuestions[currentQuestionIndex] = index

                        if index == currentQuestion.correctIndex {
                            correctCount += 1
                        }

                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    } label: {
                        HStack(spacing: 10) {
                            Text(choicePrefix(for: index))
                                .shellFont(.caption, weight: .bold)
                                .foregroundColor(TerminalTheme.greenPrimary)
                                .frame(width: 26, alignment: .leading)

                            Text(currentQuestion.choices[index])
                                .shellFont(.subheadline)
                                .foregroundColor(TerminalTheme.textPrimary)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)

                            Spacer(minLength: 8)

                            if isAnswered {
                                Text(resultLabel(for: index))
                                    .shellFont(.caption2, weight: .bold)
                                    .foregroundColor(resultColor(for: index))
                            }
                        }
                    }
                    .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedAnswerIndex == index || (isAnswered && index == currentQuestion.correctIndex)))
                    .disabled(isAnswered)
                }
            }
                }
            }

            if isAnswered {
                Button(isLastQuestion ? finalCompleteLabel : "NEXT QUESTION") {
                    if isLastQuestion {
                        showCompletion = true
                        vm.addXP(correctCount * 50)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            if let onComplete {
                                onComplete()
                            } else {
                                vm.completeLesson(lesson)
                                vm.goBack()
                            }
                        }
                    } else {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                            currentQuestionIndex += 1
                            selectedAnswerIndex = nil
                        }
                    }
                }
                .buttonStyle(ShellButtonStyle(kind: .filled))
                .transition(.opacity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .animation(.spring(response: 0.4, dampingFraction: 0.76), value: isAnswered)
        .onAppear {
            vm.resetLesson()
            currentQuestionIndex = 0
            selectedAnswerIndex = nil
            answeredQuestions = [:]
            correctCount = 0
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
        if answeredQuestions[currentQuestionIndex] == index {
            return "MISS"
        }
        return ""
    }

    private func resultColor(for index: Int) -> Color {
        index == currentQuestion.correctIndex ? TerminalTheme.greenPrimary : TerminalTheme.textTertiary
    }
}
