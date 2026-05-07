import SwiftUI

// MARK: - Lesson Learning Tab View

struct LessonLearningTabView: View {
    let lesson: Lesson
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(course.level.modernSoft)
                        .frame(width: 36, height: 36)
                    Image(systemName: "book.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(course.level.modernColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("学習資料")
                        .font(ModernFont.headlineMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                    Text("まずは内容を読んで理解しましょう")
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textSecondary)
                }
                Spacer()
            }
            .padding(.horizontal, 20)

            switch lesson.content {
            case .concept(let concept):
                ConceptLessonView(concept: concept, course: course)

            case .scenario(let scenario):
                VStack(alignment: .leading, spacing: 14) {
                    LearningSectionCard(
                        title: "シナリオ",
                        icon: "doc.text.fill",
                        color: course.level.modernColor
                    ) {
                        Text(scenario.setup)
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textPrimary)
                            .lineSpacing(6)
                    }

                    LearningSectionCard(
                        title: "目標",
                        icon: "target",
                        color: ModernTheme.success
                    ) {
                        Text(scenario.goal)
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textPrimary)
                            .lineSpacing(6)
                    }

                    LearningSectionCard(
                        title: "ステップ概要",
                        icon: "list.number",
                        color: ModernTheme.secondary
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(scenario.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("\(index + 1)")
                                        .font(ModernFont.labelLarge)
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Circle().fill(course.level.modernColor))
                                    Text(step.prompt)
                                        .font(ModernFont.bodyMedium)
                                        .foregroundColor(ModernTheme.textPrimary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

            case .quest(let quest):
                VStack(alignment: .leading, spacing: 14) {
                    LearningSectionCard(
                        title: "状況",
                        icon: "doc.text.fill",
                        color: course.level.modernColor
                    ) {
                        Text(quest.scenario)
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textPrimary)
                            .lineSpacing(6)
                    }

                    LearningSectionCard(
                        title: "あなたの任務",
                        icon: "flag.fill",
                        color: ModernTheme.success
                    ) {
                        Text(quest.prompt)
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textPrimary)
                            .lineSpacing(6)
                    }
                }
                .padding(.horizontal, 20)

            case .quiz(let quiz):
                VStack(alignment: .leading, spacing: 14) {
                    LearningSectionCard(
                        title: "クイズについて",
                        icon: "questionmark.circle.fill",
                        color: course.level.modernColor
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("全\(quiz.questions.count)問のクイズが出題されます。各問題を丁寧に読んで、正しい選択肢を選んでください。")
                                .font(ModernFont.bodyMedium)
                                .foregroundColor(ModernTheme.textPrimary)
                                .lineSpacing(6)

                            HStack(spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(ModernTheme.warning)
                                Text("間違えてもその場で解説が確認できます")
                                    .font(ModernFont.bodySmall)
                                    .foregroundColor(ModernTheme.textSecondary)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(ModernTheme.warningSoft.opacity(0.5))
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Learning Section Card

struct LearningSectionCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                Text(title)
                    .font(ModernFont.headlineSmall)
                    .foregroundColor(ModernTheme.textPrimary)
            }

            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ModernTheme.border, lineWidth: 1)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
    }
}
