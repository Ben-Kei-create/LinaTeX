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
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(TerminalTheme.accentYellow)

                VStack(alignment: .leading, spacing: 4) {
                    Text("アチーブメント")
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("あなたの成果を見る")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(unlockedBadges.count)/\(allAchievements.count)")
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(TerminalTheme.greenPrimary)
                    Text("獲得済み")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(12)
            .background(TerminalTheme.bgTertiary)
            .cornerRadius(8)

            if !unlockedBadges.isEmpty {
                // Unlocked achievements
                VStack(alignment: .leading, spacing: 10) {
                    Text("🏆 獲得済みのアチーブメント")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(TerminalTheme.accentYellow)

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                    ], spacing: 10) {
                        ForEach(unlockedBadges, id: \.id) { badge in
                            AchievementBadgeView(achievement: badge, unlocked: true)
                        }
                    }
                }
            }

            if !lockedBadges.isEmpty {
                // Locked achievements
                VStack(alignment: .leading, spacing: 10) {
                    Text("🔒 チャレンジ中のアチーブメント")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.6))

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                    ], spacing: 10) {
                        ForEach(lockedBadges, id: \.id) { badge in
                            AchievementBadgeView(achievement: badge, unlocked: false)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(16)
        .background(TerminalTheme.bgSecondary)
        .cornerRadius(12)
        .onAppear {
            vm.checkAndUnlockAchievements()
        }
    }
}

// MARK: - Achievement Badge View

struct AchievementBadgeView: View {
    let achievement: Achievement
    let unlocked: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(achievement.icon)
                .font(.system(size: 32))
                .opacity(unlocked ? 1.0 : 0.4)

            VStack(alignment: .center, spacing: 4) {
                Text(achievement.name)
                    .font(.system(.caption2, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(unlocked ? .white : .white.opacity(0.5))
                    .lineLimit(2)

                Text(achievement.description)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(unlocked ? .white.opacity(0.7) : .white.opacity(0.3))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(
            unlocked ?
            LinearGradient(
                colors: [TerminalTheme.accentYellow.opacity(0.1), TerminalTheme.accentYellow.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ) :
            LinearGradient(
                colors: [TerminalTheme.borderColor, TerminalTheme.borderColor.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    unlocked ? TerminalTheme.accentYellow.opacity(0.3) : TerminalTheme.borderColor,
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    ZStack {
        TerminalTheme.bgPrimary
            .ignoresSafeArea()

        AchievementsView(vm: AppViewModel())
            .padding(16)
    }
}
