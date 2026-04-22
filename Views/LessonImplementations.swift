import SwiftUI

// ScenarioLessonView implementation
struct ScenarioLessonViewImpl: View {
    let scenario: ScenarioLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson

    @State private var currentStepIndex = 0

    var currentStep: ScenarioStep { scenario.steps[currentStepIndex] }
    var isLastStep: Bool { currentStepIndex == scenario.steps.count - 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Progress through steps
            VStack(spacing: 8) {
                HStack {
                    Text("ステップ \(currentStepIndex + 1)/\(scenario.steps.count)")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(course.level.mainColor)
                    Spacer()
                    ProgressView(value: Double(currentStepIndex + 1) / Double(scenario.steps.count))
                        .frame(width: 100)
                }

                Text(scenario.setup)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Current step prompt
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.cyan)
                    Text("ステップ\(currentStepIndex + 1)")
                        .font(.system(.caption2, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                }

                Text(currentStep.prompt)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .lineSpacing(2)
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Hint
            Button(action: {
                withAnimation(.spring()) {
                    vm.showHint.toggle()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb\(vm.showHint ? ".fill" : "")")
                    Text(vm.showHint ? "ヒントを隠す" : "ヒントを見る")
                }
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(vm.showHint ? Color.yellow.opacity(0.2) : Color.white.opacity(0.05))
                .foregroundColor(vm.showHint ? .yellow : .white.opacity(0.6))
                .cornerRadius(6)
            }

            if vm.showHint {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(currentStep.hint)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                .padding(10)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(6)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Terminal (Fixed height)
            TerminalPanel(
                input: vm.userInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                successMessage: "✅ ステップ完了！"
            )

            // Command buttons
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(currentStep.options) { option in
                        CommandButton(
                            option: option,
                            accentColor: course.level.mainColor,
                            isSelected: vm.userInput == option.command,
                            isDisabled: vm.currentLessonState != .waiting
                        ) {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            vm.selectCommand(option)
                        }
                    }
                }

                HStack(spacing: 10) {
                    if vm.currentLessonState == .wrong {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            vm.retry()
                        }) {
                            Label("もう一度", systemImage: "arrow.counterclockwise")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.semibold)
                        }
                    }

                    if vm.currentLessonState != .correct {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .heavy)
                            impact.impactOccurred()
                            vm.executeScenarioStep(currentStep)
                        }) {
                            Label("実行", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(vm.userInput.isEmpty ? Color.gray.opacity(0.2) : course.level.mainColor)
                                .foregroundColor(vm.userInput.isEmpty ? .gray : .black)
                                .cornerRadius(8)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.bold)
                        }
                        .disabled(vm.userInput.isEmpty)
                    }

                    if vm.currentLessonState == .correct {
                        Button(action: {
                            let impact = UINotificationFeedbackGenerator()
                            impact.notificationOccurred(.success)

                            if isLastStep {
                                vm.completeLesson(lesson)
                                vm.goBack()
                            } else {
                                currentStepIndex += 1
                                vm.nextStep()
                            }
                        }) {
                            Label(isLastStep ? "完了" : "次へ", systemImage: isLastStep ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(
                                    LinearGradient(
                                        colors: [course.level.mainColor, course.level.mainColor.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.bold)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
        .padding(16)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.currentLessonState)
        .onAppear {
            vm.resetLesson()
            currentStepIndex = 0
        }
    }
}

// QuizLessonView implementation
struct QuizLessonViewImpl: View {
    let quiz: QuizLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var answeredQuestions: [Int: Int] = [:]
    @State private var correctCount = 0

    var currentQuestion: QuizQuestion { quiz.questions[currentQuestionIndex] }
    var isLastQuestion: Bool { currentQuestionIndex == quiz.questions.count - 1 }
    var isAnswered: Bool { answeredQuestions[currentQuestionIndex] != nil }
    var isCorrect: Bool { answeredQuestions[currentQuestionIndex] == currentQuestion.correctIndex }
    var quizProgress: Double { Double(answeredQuestions.count) / Double(quiz.questions.count) }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Progress
            VStack(spacing: 8) {
                HStack {
                    Text("問\(currentQuestionIndex + 1)/\(quiz.questions.count)")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(course.level.mainColor)
                    Spacer()
                    ProgressView(value: quizProgress)
                        .frame(width: 100)
                }
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Question
            VStack(alignment: .leading, spacing: 10) {
                Text(currentQuestion.question)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .lineSpacing(2)
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Choices
            VStack(spacing: 8) {
                ForEach(0..<currentQuestion.choices.count, id: \.self) { index in
                    Button(action: {
                        if !isAnswered {
                            selectedAnswerIndex = index
                            answeredQuestions[currentQuestionIndex] = index
                            if index == currentQuestion.correctIndex {
                                correctCount += 1
                            }
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isAnswered ? (index == currentQuestion.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill") : "circle")
                                .foregroundColor(isAnswered ? (index == currentQuestion.correctIndex ? .green : .red) : .white.opacity(0.5))
                                .font(.system(size: 18))

                            Text(currentQuestion.choices[index])
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .padding(12)
                        .background(
                            isAnswered ? (index == currentQuestion.correctIndex ? Color.green.opacity(0.1) : (index == answeredQuestions[currentQuestionIndex] ? Color.red.opacity(0.1) : Color.white.opacity(0.05))) : (selectedAnswerIndex == index ? Color.white.opacity(0.1) : Color.white.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isAnswered ? (index == currentQuestion.correctIndex ? Color.green : (index == answeredQuestions[currentQuestionIndex] ? Color.red : Color.transparent)) : (selectedAnswerIndex == index ? course.level.mainColor : Color.white.opacity(0.1)), lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                    .disabled(isAnswered)
                }
            }
            .padding(.vertical, 4)

            // Explanation (if answered)
            if isAnswered {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "info.circle.fill")
                            .foregroundColor(isCorrect ? .green : .cyan)
                        Text(isCorrect ? "正解！" : "解説：")
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .cyan)
                    }

                    Text(currentQuestion.explanation)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(2)
                }
                .padding(10)
                .background((isCorrect ? Color.green : Color.cyan).opacity(0.1))
                .cornerRadius(6)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer()

            // Next button
            if isAnswered {
                Button(action: {
                    if isLastQuestion {
                        vm.addXP(correctCount * 50)
                        vm.completeLesson(lesson)
                        vm.goBack()
                    } else {
                        currentQuestionIndex += 1
                        selectedAnswerIndex = nil
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: isLastQuestion ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                        Text(isLastQuestion ? "完了" : "次へ")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(
                        LinearGradient(
                            colors: [course.level.mainColor, course.level.mainColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.bold)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(16)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isAnswered)
        .onAppear {
            vm.resetLesson()
            currentQuestionIndex = 0
        }
    }
}

extension Color {
    static var transparent: Color {
        Color.white.opacity(0)
    }
}
