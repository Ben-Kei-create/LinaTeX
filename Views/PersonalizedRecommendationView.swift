import SwiftUI

// MARK: - Personalized Recommendation Card

struct PersonalizedRecommendationView: View {
    @ObservedObject var vm: AppViewModel
    let onSelectLesson: (Lesson) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let recommendation = vm.personalizedRecommendation {
                // Header with Priority Indicator
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: priorityIcon(recommendation.priority))
                        .font(.system(size: 20))
                        .foregroundColor(priorityColor(recommendation.priority))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(recommendation.title)
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(recommendation.reason)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()
                }

                Divider()
                    .background(Color.white.opacity(0.1))

                // Recommended Lessons
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(recommendation.lessons, id: \.id) { lesson in
                        RecommendedLessonCard(lesson: lesson) {
                            onSelectLesson(lesson)
                        }
                    }
                }
            } else {
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "hourglass.circle")
                        .font(.system(size: 32))
                        .foregroundColor(.cyan.opacity(0.5))

                    Text("分析中...")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))

                    Text("もっとレッスンを進めると、AIが個人化された推奨を提供します")
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: [
                    Color.cyan.opacity(0.1),
                    Color.cyan.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
        )
        .onAppear {
            vm.updateLearningProfile()
            vm.updatePersonalizedRecommendation()
        }
    }

    private func priorityIcon(_ priority: Int) -> String {
        switch priority {
        case 1: return "exclamationmark.circle.fill"
        case 2: return "star.circle.fill"
        default: return "checkmark.circle.fill"
        }
    }

    private func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 1: return .red
        case 2: return .yellow
        default: return .green
        }
    }
}

// MARK: - Recommended Lesson Card

struct RecommendedLessonCard: View {
    let lesson: Lesson
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("\(lesson.estimatedMinutes)分")
                            .font(.system(.caption2, design: .monospaced))
                    }
                    .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                HStack(spacing: 6) {
                    Text(lesson.emoji)
                        .font(.system(size: 16))

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.cyan)
                }
            }
            .padding(10)
            .background(Color.white.opacity(0.05))
            .cornerRadius(6)
        }
    }
}

// MARK: - Learning Profile Summary Widget

struct LearningProfileWidget: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            HStack(spacing: 8) {
                Image(systemName: "brain")
                    .font(.system(size: 16))
                    .foregroundColor(.purple)

                Text("AI学習分析")
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Text("Beta")
                    .font(.system(.caption2, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(4)
            }

            Divider()
                .background(Color.white.opacity(0.1))

            // Learning Style
            if let profile = vm.learningProfile {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 8, height: 8)

                        Text("学習スタイル")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))

                        Spacer()

                        Text(styleLabel(profile.learningStyle))
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                    }

                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 8, height: 8)

                        Text("学習ペース")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))

                        Spacer()

                        Text(paceLabel(profile.pace))
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }

                    if !profile.weakTopics.isEmpty {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)

                            Text("強化すべき分野")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))

                            Spacer()

                            Text(profile.weakTopics.first ?? "")
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(Color(red: 0.11, green: 0.11, blue: 0.16))
        .cornerRadius(8)
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

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.08, blue: 0.13)
            .ignoresSafeArea()

        VStack(spacing: 16) {
            PersonalizedRecommendationView(vm: AppViewModel()) { _ in }
            LearningProfileWidget(vm: AppViewModel())

            Spacer()
        }
        .padding(16)
    }
}
