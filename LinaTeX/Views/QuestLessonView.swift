import SwiftUI

// MARK: - Quest Lesson View

struct QuestLessonView: View {
    let quest: QuestLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    @State private var showCompletion = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ProblemInstructionCard(
                title: "状況",
                icon: "quote.bubble.fill",
                color: course.level.modernColor
            ) {
                Text(quest.scenario)
                    .font(ModernFont.bodyMedium)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineSpacing(5)
            }

            ProblemInstructionCard(
                title: "問題",
                icon: "questionmark.circle.fill",
                color: ModernTheme.secondary
            ) {
                Text(quest.prompt)
                    .font(ModernFont.bodyLarge)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineSpacing(5)
            }

            TerminalPanel(
                input: vm.userInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                successMessage: quest.successMessage
            )

            CommandChoiceSection(
                title: "選択肢",
                subtitle: "答えだと思うコマンドを選んでから実行します",
                options: quest.options,
                selectedCommand: vm.userInput,
                accentColor: course.level.modernColor,
                isDisabled: vm.currentLessonState != .waiting
            ) { option in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                vm.selectCommand(option)
            }

            if vm.currentLessonState == .wrong {
                QuizExplanationCard(
                    isCorrect: false,
                    explanation: "学習で確認したコマンドの役割と、今回の問題で求められている操作を照らし合わせて選び直してください。"
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            if vm.currentLessonState == .correct {
                QuizExplanationCard(
                    isCorrect: true,
                    explanation: quest.successMessage
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
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
                        vm.retry()
                    }
                }

                if vm.currentLessonState != .correct && vm.currentLessonState != .completed {
                    PrimaryActionButton(
                        title: "実行",
                        icon: "play.fill",
                        style: .primary,
                        color: course.level.modernColor,
                        disabled: vm.userInput.isEmpty
                    ) {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        vm.executeQuest(quest)
                    }
                }

                if vm.currentLessonState == .correct {
                    PrimaryActionButton(
                        title: "完了",
                        icon: "checkmark.circle.fill",
                        style: .success
                    ) {
                        let impact = UINotificationFeedbackGenerator()
                        impact.notificationOccurred(.success)
                        showCompletion = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            vm.completeLesson(lesson)
                            vm.goBack()
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, 20)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.currentLessonState)
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
    }
}
