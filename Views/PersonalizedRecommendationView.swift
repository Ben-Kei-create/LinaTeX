import SwiftUI

// MARK: - Personalized Recommendation Card

struct PersonalizedRecommendationView: View {
    @ObservedObject var vm: AppViewModel
    let onSelectLesson: (Lesson) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let recommendation = vm.personalizedRecommendation {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(priorityColor(recommendation.priority).opacity(0.15))
                            .frame(width: 38, height: 38)
                        Image(systemName: priorityIcon(recommendation.priority))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(priorityColor(recommendation.priority))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(recommendation.title)
                            .font(ModernFont.headlineSmall)
                            .foregroundColor(ModernTheme.textPrimary)

                        Text(recommendation.reason)
                            .font(ModernFont.bodySmall)
                            .foregroundColor(ModernTheme.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recommendation.lessons, id: \.id) { lesson in
                        RecommendedLessonCard(lesson: lesson) {
                            onSelectLesson(lesson)
                        }
                    }
                }
            } else {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(ModernTheme.primarySoft)
                            .frame(width: 38, height: 38)
                        Image(systemName: "sparkles")
                            .foregroundColor(ModernTheme.primary)
                            .font(.system(size: 14, weight: .semibold))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("AIがあなたに最適なレッスンを準備中")
                            .font(ModernFont.bodyEmphasizedSmall)
                            .foregroundColor(ModernTheme.textPrimary)
                        Text("レッスンを進めると、おすすめが表示されます")
                            .font(ModernFont.captionSmall)
                            .foregroundColor(ModernTheme.textSecondary)
                    }

                    Spacer()
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(ModernTheme.border, lineWidth: 1)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
        .onAppear {
            vm.updateLearningProfile()
            vm.updatePersonalizedRecommendation()
        }
    }

    private func priorityIcon(_ priority: Int) -> String {
        switch priority {
        case 1: return "flame.fill"
        case 2: return "star.fill"
        default: return "sparkles"
        }
    }

    private func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 1: return ModernTheme.danger
        case 2: return ModernTheme.warning
        default: return ModernTheme.primary
        }
    }
}

// MARK: - Recommended Lesson Card

struct RecommendedLessonCard: View {
    let lesson: Lesson
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(lesson.emoji)
                    .font(.system(size: 22))
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(ModernTheme.bgSubtle))

                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(ModernFont.bodyEmphasizedSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(lesson.estimatedMinutes)分")
                            .font(ModernFont.labelSmall)
                    }
                    .foregroundColor(ModernTheme.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ModernTheme.primary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ModernTheme.bgSubtle.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Learning Profile Summary Widget

struct LearningProfileWidget: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(ModernTheme.accentSoft)
                        .frame(width: 36, height: 36)
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(ModernTheme.accent)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("AI学習分析")
                        .font(ModernFont.headlineSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                    Text("あなたに合わせた学習プロフィール")
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textSecondary)
                }

                Spacer()
            }

            if let profile = vm.learningProfile {
                VStack(spacing: 10) {
                    ProfileRow(
                        icon: "graduationcap.fill",
                        label: "学習スタイル",
                        value: styleLabel(profile.learningStyle),
                        color: ModernTheme.primary
                    )
                    ProfileRow(
                        icon: "speedometer",
                        label: "学習ペース",
                        value: paceLabel(profile.pace),
                        color: ModernTheme.secondary
                    )
                    if !profile.weakTopics.isEmpty {
                        ProfileRow(
                            icon: "exclamationmark.triangle.fill",
                            label: "強化分野",
                            value: profile.weakTopics.first ?? "",
                            color: ModernTheme.warning
                        )
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(ModernTheme.border, lineWidth: 1)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
        .onAppear {
            vm.updateLearningProfile()
        }
    }

    private func styleLabel(_ style: LearningStyle) -> String {
        switch style {
        case .conceptPreferred: return "理論型"
        case .questPreferred: return "シンプルタスク型"
        case .scenarioPreferred: return "実践型"
        case .quizPreferred: return "確認型"
        case .balanced: return "バランス型"
        }
    }

    private func paceLabel(_ pace: LearningPace) -> String {
        switch pace {
        case .slow: return "ゆっくり"
        case .normal: return "通常"
        case .fast: return "速い"
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 22)
            Text(label)
                .font(ModernFont.bodySmall)
                .foregroundColor(ModernTheme.textSecondary)
            Spacer()
            Text(value)
                .font(ModernFont.bodyEmphasizedSmall)
                .foregroundColor(ModernTheme.textPrimary)
        }
    }
}

#Preview {
    ZStack {
        ModernTheme.backgroundGradient
            .ignoresSafeArea()

        VStack(spacing: 16) {
            PersonalizedRecommendationView(vm: AppViewModel()) { _ in }
            LearningProfileWidget(vm: AppViewModel())
            Spacer()
        }
        .padding(20)
    }
}
