import SwiftUI

// MARK: - Statistics View

struct StatisticsView: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.cyan)

                VStack(alignment: .leading, spacing: 4) {
                    Text("学習統計")
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("あなたの進捗をみる")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Key Stats Grid
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    StatCard(
                        title: "合計XP",
                        value: "\(vm.totalXP)",
                        icon: "star.fill",
                        color: .yellow
                    )

                    StatCard(
                        title: "連続完了",
                        value: "\(vm.streak)",
                        icon: "flame.fill",
                        color: .orange
                    )
                }

                HStack(spacing: 12) {
                    StatCard(
                        title: "完了レッスン",
                        value: "\(vm.completedLessons.count)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )

                    StatCard(
                        title: "成功率",
                        value: String(format: "%.0f%%", vm.successRate),
                        icon: "target",
                        color: .cyan
                    )
                }
            }

            // AI Learning Profile
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16))
                        .foregroundColor(.purple)
                    Text("🤖 あなたの学習プロフィール")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("学習スタイル")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(vm.getLearningStyleDescription())
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                    }

                    if !vm.getWeakAreasString().contains("弱点なし") {
                        HStack {
                            Text("強化が必要")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text(vm.getWeakAreasString())
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                    }

                    HStack {
                        Text("推奨アクション")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(vm.getRecommendedNextSteps())
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
                .padding(10)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(6)
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Progress Overview
            VStack(alignment: .leading, spacing: 10) {
                Text("コース進捗")
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                ForEach(vm.courses, id: \.id) { course in
                    ProgressRow(
                        title: course.title,
                        progress: vm.progressInCourse(course),
                        color: course.level.mainColor
                    )
                }
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            // Total Progress
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("全体進捗")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(String(format: "%.1f%%", vm.totalProgress() * 100))
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                }

                ProgressView(value: vm.totalProgress())
                    .tint(.cyan)

                Text("推定完了: 約\(vm.learningProfile?.estimatedCompletionDays ?? 0)日")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(12)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(8)

            Spacer()
        }
        .padding(16)
        .background(Color(red: 0.08, green: 0.08, blue: 0.13))
        .cornerRadius(12)
        .onAppear {
            vm.updateLearningProfile()
            vm.updatePersonalizedRecommendation()
        }
    }
}

// MARK: - Statistics Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)

                Spacer()
            }

            Text(value)
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            LinearGradient(
                colors: [
                    color.opacity(0.15),
                    color.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Progress Row

struct ProgressRow: View {
    let title: String
    let progress: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white)

                Spacer()

                Text(String(format: "%.0f%%", progress * 100))
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }

            ProgressView(value: progress)
                .tint(color)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.08, blue: 0.13)
            .ignoresSafeArea()

        StatisticsView(vm: AppViewModel())
            .padding(16)
    }
}
