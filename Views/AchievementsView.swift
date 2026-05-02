import SwiftUI

// MARK: - Achievements View

struct AchievementsView: View {
    @ObservedObject var vm: AppViewModel

    var unlockedBadges: [Achievement] {
        vm.getUnlockedBadges()
    }

    var lockedBadges: [Achievement] {
        allAchievements.filter { !vm.unlockedAchievements.contains($0.id) }
    }

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("アチーブメント")
                                .font(ModernFont.displayMedium)
                                .foregroundColor(ModernTheme.textPrimary)
                            Text("学習の成果を確認しましょう")
                                .font(ModernFont.bodyMedium)
                                .foregroundColor(ModernTheme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Stats card
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("獲得済み")
                                .font(ModernFont.labelMedium)
                                .foregroundColor(.white.opacity(0.85))
                            Text("\(unlockedBadges.count) / \(allAchievements.count)")
                                .font(ModernFont.displayMedium)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.18))
                                .frame(width: 64, height: 64)
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: 0xF59E0B), Color(hex: 0xEF4444)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .shadow(color: Color(hex: 0xF59E0B).opacity(0.25), radius: 16, x: 0, y: 6)
                    .padding(.horizontal, 20)

                    // Unlocked
                    if !unlockedBadges.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(ModernTheme.success)
                                Text("獲得済み")
                                    .font(ModernFont.headlineMedium)
                                    .foregroundColor(ModernTheme.textPrimary)
                            }
                            .padding(.horizontal, 20)

                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                            ], spacing: 12) {
                                ForEach(unlockedBadges, id: \.id) { badge in
                                    AchievementBadgeView(achievement: badge, unlocked: true)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    // Locked
                    if !lockedBadges.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(ModernTheme.textTertiary)
                                Text("チャレンジ中")
                                    .font(ModernFont.headlineMedium)
                                    .foregroundColor(ModernTheme.textPrimary)
                            }
                            .padding(.horizontal, 20)

                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                            ], spacing: 12) {
                                ForEach(lockedBadges, id: \.id) { badge in
                                    AchievementBadgeView(achievement: badge, unlocked: false)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .onAppear {
            vm.checkAndUnlockAchievements()
        }
    }
}

// MARK: - Achievement Badge

struct AchievementBadgeView: View {
    let achievement: Achievement
    let unlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(unlocked ? ModernTheme.warningSoft : ModernTheme.bgSubtle)
                    .frame(width: 56, height: 56)
                Text(achievement.icon)
                    .font(.system(size: 30))
                    .opacity(unlocked ? 1.0 : 0.4)
            }

            VStack(spacing: 2) {
                Text(achievement.name)
                    .font(ModernFont.labelMedium)
                    .foregroundColor(unlocked ? ModernTheme.textPrimary : ModernTheme.textTertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(achievement.description)
                    .font(ModernFont.captionSmall)
                    .foregroundColor(unlocked ? ModernTheme.textSecondary : ModernTheme.textTertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    unlocked ? ModernTheme.warning.opacity(0.4) : ModernTheme.border,
                    lineWidth: 1
                )
        )
        .shadow(
            color: unlocked ? ModernTheme.warning.opacity(0.15) : ModernTheme.shadowColor,
            radius: 8, x: 0, y: 2
        )
    }
}

#Preview {
    AchievementsView(vm: AppViewModel())
}
