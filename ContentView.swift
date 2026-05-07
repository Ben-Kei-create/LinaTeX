import SwiftUI

struct ContentView: View {
    @StateObject private var vm = AppViewModel()

    var body: some View {
        NavigationStack(path: $vm.navigationPath) {
            HomeView(vm: vm)
                .navigationDestination(for: AppScreen.self) { screen in
                    switch screen {
                    case .courseDetail(let course):
                        CourseDetailView(course: course, vm: vm)
                    case .lesson(let lesson, let course):
                        LessonView(lesson: lesson, course: course, vm: vm)
                    case .home:
                        HomeView(vm: vm)
                    }
                }
        }
        .preferredColorScheme(.light)
        .tint(ModernTheme.primary)
    }
}

// MARK: - Lesson View (Main lesson container)

struct LessonView: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    @State private var selectedTab: LessonTab = .learning

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { vm.goBack() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("戻る")
                                .font(ModernFont.bodyEmphasizedSmall)
                        }
                        .foregroundColor(course.level.modernColor)
                    }
                    Spacer()
                    Text(course.title)
                        .font(ModernFont.bodyEmphasizedSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Color.clear.frame(width: 56, height: 1)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(ModernTheme.bgCard.opacity(0.7))
                .overlay(
                    Rectangle()
                        .fill(ModernTheme.border)
                        .frame(height: 1),
                    alignment: .bottom
                )

                ScrollView {
                    VStack(spacing: 18) {
                        // Lesson Header Card
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(course.level.modernSoft)
                                    .frame(width: 56, height: 56)
                                Text(lesson.emoji)
                                    .font(.system(size: 30))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(lesson.title)
                                    .font(ModernFont.headlineMedium)
                                    .foregroundColor(ModernTheme.textPrimary)
                                HStack(spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 11))
                                        Text("\(lesson.estimatedMinutes)分")
                                            .font(ModernFont.labelMedium)
                                    }
                                    .foregroundColor(ModernTheme.textTertiary)

                                    Text(lesson.content.typeLabel)
                                        .modernPill(color: course.level.modernColor)
                                }
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(ModernTheme.bgCard)
                        )
                        .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
                        .padding(.horizontal, 20)

                        // Flow indicator
                        LessonFlowIndicator(
                            currentTab: selectedTab,
                            isCompleted: vm.isLessonCompleted(lesson),
                            color: course.level.modernColor
                        )
                        .padding(.horizontal, 20)

                        // Content based on selected tab
                        Group {
                            if selectedTab == .learning {
                                LessonLearningTabView(lesson: lesson, course: course)
                            } else {
                                switch lesson.content {
                                case .concept(let concept):
                                    ConceptLessonView(concept: concept, course: course)
                                case .quest(let quest):
                                    QuestLessonView(quest: quest, course: course, vm: vm, lesson: lesson)
                                case .scenario(let scenario):
                                    ScenarioLessonView(scenario: scenario, course: course, vm: vm, lesson: lesson)
                                case .quiz(let quiz):
                                    QuizLessonView(quiz: quiz, course: course, vm: vm, lesson: lesson)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }

                // Footer: Tab selector + Ad
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        TabSelectorButton(
                            icon: "book.fill",
                            label: "学習",
                            isSelected: selectedTab == .learning,
                            color: course.level.modernColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedTab = .learning
                            }
                        }

                        TabSelectorButton(
                            icon: "target",
                            label: "問題に挑戦",
                            isSelected: selectedTab == .problem,
                            color: course.level.modernColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedTab = .problem
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Ad banner
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ModernTheme.warning)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("LinaTeX Pro")
                                .font(ModernFont.labelLarge)
                                .foregroundColor(ModernTheme.textPrimary)
                            Text("広告")
                                .font(ModernFont.captionSmall)
                                .foregroundColor(ModernTheme.textTertiary)
                        }
                        Spacer()
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(ModernTheme.textTertiary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ModernTheme.warningSoft.opacity(0.5))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ModernTheme.warning.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
                .background(
                    ModernTheme.bgCard
                        .opacity(0.85)
                        .ignoresSafeArea(edges: .bottom)
                )
                .overlay(
                    Rectangle()
                        .fill(ModernTheme.border)
                        .frame(height: 1),
                    alignment: .top
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            vm.resetLesson()
        }
    }
}

// MARK: - Color Extensions

extension Color {
    static var transparent: Color {
        Color.white.opacity(0)
    }
}

// MARK: - Lesson Implementations Reference

typealias ScenarioLessonView = ScenarioLessonViewImpl
typealias QuizLessonView = QuizLessonViewImpl

#Preview {
    ContentView()
}
