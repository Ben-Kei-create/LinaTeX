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

// MARK: - Lesson View

struct LessonView: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    @State private var selectedTab: LessonTab = .learning

    // Concept-only lessons have no interactive "Problem" step — show one scrollable page.
    private var isConceptOnly: Bool {
        if case .concept = lesson.content { return true }
        return false
    }

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // ── Header ──────────────────────────────────────────────────
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
                .overlay(Rectangle().fill(ModernTheme.border).frame(height: 0.5), alignment: .bottom)

                // ── Content ─────────────────────────────────────────────────
                ScrollView {
                    VStack(spacing: 14) {
                        // Lesson header card
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
                                        Image(systemName: "clock.fill").font(.system(size: 9))
                                        Text("\(lesson.estimatedMinutes)分").font(ModernFont.labelSmall)
                                    }
                                    .foregroundColor(ModernTheme.textTertiary)
                                    Text(lesson.content.typeLabel)
                                        .modernPill(color: course.level.modernColor)
                                }
                            }
                            Spacer()
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(ModernTheme.bgCard))
                        .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 1)
                        .padding(.horizontal, 16)

                        if isConceptOnly {
                            // Concept lessons: single scroll page, no Learning/Problem split
                            LessonLearningTabView(lesson: lesson, course: course)

                            PrimaryActionButton(
                                title: vm.isLessonCompleted(lesson) ? "学習完了済み" : "学習完了にする",
                                icon: vm.isLessonCompleted(lesson) ? "checkmark.circle.fill" : "book.closed.fill",
                                style: vm.isLessonCompleted(lesson) ? .secondary : .success,
                                color: ModernTheme.success,
                                disabled: vm.isLessonCompleted(lesson)
                            ) {
                                let impact = UINotificationFeedbackGenerator()
                                impact.notificationOccurred(.success)
                                vm.completeLesson(lesson)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    vm.goBack()
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)

                        } else {
                            // Quest / Scenario / Quiz: Learning ↔ Problem tabs
                            LessonFlowIndicator(
                                currentTab: selectedTab,
                                isCompleted: vm.isLessonCompleted(lesson),
                                color: course.level.modernColor
                            )
                            .padding(.horizontal, 16)

                            Group {
                                if selectedTab == .learning {
                                    LessonLearningTabView(lesson: lesson, course: course)
                                        .onAppear { vm.resetLesson() }
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
                            .onChange(of: selectedTab) { _ in
                                vm.resetLesson()
                            }
                        }
                    }
                    .padding(.vertical, 12)
                }

                // ── Footer ──────────────────────────────────────────────────
                VStack(spacing: 0) {
                    if !isConceptOnly {
                        HStack(spacing: 8) {
                            TabSelectorButton(
                                icon: "book.fill", label: "学習",
                                isSelected: selectedTab == .learning,
                                color: course.level.modernColor
                            ) {
                                withAnimation(.easeInOut(duration: 0.25)) { selectedTab = .learning }
                            }
                            TabSelectorButton(
                                icon: "target", label: "問題",
                                isSelected: selectedTab == .problem,
                                color: course.level.modernColor
                            ) {
                                withAnimation(.easeInOut(duration: 0.25)) { selectedTab = .problem }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 6)
                        .background(ModernTheme.bgCard.opacity(0.85))
                        .overlay(Rectangle().fill(ModernTheme.border).frame(height: 1), alignment: .top)
                    }

                    AdBannerView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { vm.resetLesson() }
    }
}

// MARK: - Color Extensions

extension Color {
    static var transparent: Color { Color.white.opacity(0) }
}

// MARK: - Lesson Implementations Reference

typealias ScenarioLessonView = ScenarioLessonViewImpl
typealias QuizLessonView = QuizLessonViewImpl

#Preview {
    ContentView()
}
