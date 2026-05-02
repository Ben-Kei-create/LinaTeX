import SwiftUI

// MARK: - Statistics View

struct StatisticsView: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("学習統計")
                            .font(ModernFont.displayMedium)
                            .foregroundColor(ModernTheme.textPrimary)
                        Text("あなたの進捗を確認しましょう")
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Hero Progress Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("全体進捗")
                                    .font(ModernFont.labelMedium)
                                    .foregroundColor(.white.opacity(0.85))
                                Text(String(format: "%.1f%%", vm.totalProgress() * 100))
                                    .font(ModernFont.displayLarge)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.85))
                        }

                        ProgressBarView(
                            progress: vm.totalProgress(),
                            tint: .white,
                            track: Color.white.opacity(0.25)
                        )

                        Text("推定完了: 約\(vm.learningProfile?.estimatedCompletionDays ?? 0)日")
                            .font(ModernFont.captionSmall)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ModernTheme.heroGradient)
                    )
                    .shadow(color: ModernTheme.secondary.opacity(0.25), radius: 16, x: 0, y: 6)
                    .padding(.horizontal, 20)

                    // Course Progress
                    VStack(alignment: .leading, spacing: 12) {
                        Text("コース別進捗")
                            .font(ModernFont.headlineMedium)
                            .foregroundColor(ModernTheme.textPrimary)

                        VStack(spacing: 12) {
                            ForEach(vm.courses, id: \.id) { course in
                                ProgressRow(
                                    title: course.title,
                                    progress: vm.progressInCourse(course),
                                    color: course.level.modernColor,
                                    emoji: course.emoji
                                )
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(ModernTheme.bgCard)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(ModernTheme.border, lineWidth: 1)
                    )
                    .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
                    .padding(.horizontal, 20)

                    // AI Profile Card
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

                            Text("学習プロフィール")
                                .font(ModernFont.headlineMedium)
                                .foregroundColor(ModernTheme.textPrimary)

                            Spacer()
                        }

                        VStack(spacing: 12) {
                            ProfileStat(
                                icon: "graduationcap.fill",
                                label: "学習スタイル",
                                value: vm.getLearningStyleDescription(),
                                color: ModernTheme.primary
                            )

                            if !vm.getWeakAreasString().contains("弱点なし") {
                                ProfileStat(
                                    icon: "exclamationmark.triangle.fill",
                                    label: "強化が必要",
                                    value: vm.getWeakAreasString(),
                                    color: ModernTheme.warning
                                )
                            }

                            ProfileStat(
                                icon: "lightbulb.fill",
                                label: "推奨アクション",
                                value: vm.getRecommendedNextSteps(),
                                color: ModernTheme.secondary
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(ModernTheme.bgCard)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(ModernTheme.border, lineWidth: 1)
                    )
                    .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
                    .padding(.horizontal, 20)

                    Spacer(minLength: 30)
                }
            }
        }
        .onAppear {
            vm.updateLearningProfile()
            vm.updatePersonalizedRecommendation()
        }
    }
}

// MARK: - Progress Row

struct ProgressRow: View {
    let title: String
    let progress: Double
    let color: Color
    var emoji: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                if let emoji = emoji {
                    Text(emoji)
                        .font(.system(size: 18))
                }
                Text(title)
                    .font(ModernFont.bodyEmphasizedSmall)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineLimit(1)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(ModernFont.labelLarge)
                    .foregroundColor(color)
            }

            ProgressBarView(
                progress: progress,
                tint: color,
                track: ModernTheme.bgSubtle
            )
        }
    }
}

// MARK: - Profile Stat

struct ProfileStat: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(ModernFont.captionSmall)
                    .foregroundColor(ModernTheme.textTertiary)
                Text(value)
                    .font(ModernFont.bodyEmphasizedSmall)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineLimit(2)
            }

            Spacer()
        }
    }
}

#Preview {
    StatisticsView(vm: AppViewModel())
}
