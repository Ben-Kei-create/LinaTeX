import SwiftUI

struct ContentView: View {
    @StateObject private var vm = AppViewModel()

    var body: some View {
        NavigationStack(path: $vm.navigationPath) {
            HomeView(vm: vm)
                .navigationDestination(for: AppScreen.self) { screen in
                    switch screen {
                    case .commandDictionary:
                        CommandDictionaryView(vm: vm)
                    case .courseDetail(let course):
                        CourseDetailView(course: course, vm: vm)
                    case .chapter(_, let course):
                        CourseDetailView(course: course, vm: vm)
                    case .lesson(let lesson, let course):
                        LessonView(lesson: lesson, course: course, vm: vm)
                    case .home:
                        HomeView(vm: vm)
                    }
                }
        }
        .preferredColorScheme(vm.isDarkMode ? .dark : .light)
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
                // Header - compact
                HStack {
                    Button(action: { vm.goBack() }) {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("戻る")
                                .font(ModernFont.labelMedium)
                        }
                        .foregroundColor(course.level.modernColor)
                    }
                    Spacer()
                    Text(course.title)
                        .font(ModernFont.labelMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(1)
                    Spacer()
                    Color.clear.frame(width: 44, height: 1)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(ModernTheme.bgCard.opacity(0.6))
                .overlay(
                    Rectangle()
                        .fill(ModernTheme.border)
                        .frame(height: 0.5),
                    alignment: .bottom
                )

                ScrollView {
                    VStack(spacing: 14) {
                        // Lesson Header Card - compact
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(course.level.modernSoft)
                                    .frame(width: 44, height: 44)
                                Text(lesson.emoji)
                                    .font(.system(size: 24))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(lesson.title)
                                    .font(ModernFont.headlineSmall)
                                    .foregroundColor(ModernTheme.textPrimary)
                                HStack(spacing: 6) {
                                    HStack(spacing: 2) {
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 9))
                                        Text("\(lesson.estimatedMinutes)分")
                                            .font(ModernFont.labelSmall)
                                    }
                                    .foregroundColor(ModernTheme.textTertiary)

                                    Text(lesson.content.typeLabel)
                                        .modernPill(color: course.level.modernColor)
                                }
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(ModernTheme.bgCard)
                        )
                        .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 1)
                        .padding(.horizontal, 16)

                        // Flow indicator
                        LessonFlowIndicator(
                            currentTab: selectedTab,
                            isCompleted: vm.isLessonCompleted(lesson),
                            color: course.level.modernColor
                        )
                        .padding(.horizontal, 16)

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
                    .padding(.vertical, 12)
                }

                // Footer: Tab selector + Ad - compact
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
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
                            label: "問題",
                            isSelected: selectedTab == .problem,
                            color: course.level.modernColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedTab = .problem
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Ad banner - compact
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(ModernTheme.warning)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("LinaTeX Pro")
                                .font(ModernFont.labelSmall)
                                .foregroundColor(ModernTheme.textPrimary)
                            Text("広告")
                                .font(ModernFont.captionSmall)
                                .foregroundColor(ModernTheme.textTertiary)
                        }
                        Spacer()
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(ModernTheme.textTertiary)
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ModernTheme.warningSoft.opacity(0.3))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ModernTheme.warning.opacity(0.15), lineWidth: 0.5)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
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
