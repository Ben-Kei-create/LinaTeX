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

// MARK: - Home View

struct HomeView: View {
    @ObservedObject var vm: AppViewModel
    @State private var selectedCourse: Course?

    var totalCompleted: Int { vm.completedLessons.count }
    var totalLessons: Int { vm.courses.reduce(0) { $0 + $1.totalLessons } }

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: - Hero Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("LinaTeX")
                                    .font(ModernFont.displayLarge)
                                    .foregroundColor(ModernTheme.textPrimary)

                                Text("Linuxを楽しく学ぼう")
                                    .font(ModernFont.bodyMedium)
                                    .foregroundColor(ModernTheme.textSecondary)
                            }
                            Spacer()
                            NavigationLink(destination: StatisticsView(vm: vm)) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(ModernTheme.primary)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle().fill(ModernTheme.bgCard)
                                    )
                                    .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // MARK: - Progress Card (Hero Style)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("学習進捗")
                                    .font(ModernFont.labelMedium)
                                    .foregroundColor(.white.opacity(0.85))
                                Text("\(totalCompleted) / \(totalLessons) レッスン")
                                    .font(ModernFont.headlineMedium)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("\(Int(vm.totalProgress() * 100))%")
                                .font(ModernFont.displayMedium)
                                .foregroundColor(.white)
                        }

                        ProgressBarView(
                            progress: vm.totalProgress(),
                            tint: .white,
                            track: Color.white.opacity(0.25)
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ModernTheme.heroGradient)
                    )
                    .shadow(color: ModernTheme.secondary.opacity(0.25), radius: 20, x: 0, y: 8)
                    .padding(.horizontal, 20)

                    // MARK: - AI Recommendation
                    PersonalizedRecommendationView(vm: vm) { lesson in
                        if let course = vm.courses.first(where: { course in
                            course.chapters.contains { chapter in
                                chapter.lessons.contains { $0.id == lesson.id }
                            }
                        }) {
                            vm.navigateToLesson(lesson, in: course)
                        }
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Courses Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("コース一覧")
                                .font(ModernFont.headlineLarge)
                                .foregroundColor(ModernTheme.textPrimary)
                            Spacer()
                            Text("\(vm.courses.count)コース")
                                .font(ModernFont.labelMedium)
                                .foregroundColor(ModernTheme.textTertiary)
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 14) {
                            ForEach(vm.courses) { course in
                                CourseCard(course: course, vm: vm)
                                    .onTapGesture {
                                        vm.navigateToCourse(course)
                                    }
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Progress Bar (Reusable)

struct ProgressBarView: View {
    let progress: Double
    var tint: Color = ModernTheme.primary
    var track: Color = ModernTheme.bgSubtle
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(track)
                Capsule()
                    .fill(tint)
                    .frame(width: max(0, geo.size.width * progress))
            }
        }
        .frame(height: height)
    }
}

// MARK: - Course Card

struct CourseCard: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var progress: Double { vm.progressInCourse(course) }
    var completedLessons: Int {
        course.chapters.reduce(0) { total, chapter in
            total + chapter.lessons.filter { vm.isLessonCompleted($0) }.count
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                // Level emoji badge
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(course.level.modernGradient)
                        .frame(width: 56, height: 56)
                    Text(course.emoji)
                        .font(.system(size: 30))
                }
                .shadow(color: course.level.modernColor.opacity(0.3), radius: 8, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text(course.level.japanese)
                        .modernPill(color: course.level.modernColor)

                    Text(course.title)
                        .font(ModernFont.headlineMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(2)

                    Text(course.subtitle)
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)
            }

            Text(course.description)
                .font(ModernFont.bodySmall)
                .foregroundColor(ModernTheme.textSecondary)
                .lineSpacing(3)
                .lineLimit(3)

            // Stats row
            HStack(spacing: 16) {
                Label {
                    Text("\(course.totalLessons)レッスン")
                        .font(ModernFont.labelMedium)
                } icon: {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 12))
                }
                .foregroundColor(ModernTheme.textSecondary)

                Label {
                    Text("\(course.estimatedMinutes)分")
                        .font(ModernFont.labelMedium)
                } icon: {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                }
                .foregroundColor(ModernTheme.textSecondary)

                Spacer()

                if progress > 0 {
                    Text("\(Int(progress * 100))%")
                        .font(ModernFont.labelLarge)
                        .foregroundColor(course.level.modernColor)
                }
            }

            // Progress bar
            VStack(alignment: .leading, spacing: 6) {
                ProgressBarView(
                    progress: progress,
                    tint: course.level.modernColor,
                    track: ModernTheme.bgSubtle
                )

                if progress > 0 {
                    Text("\(completedLessons) / \(course.totalLessons) 完了")
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textTertiary)
                }
            }
        }
        .padding(18)
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
    }
}

// MARK: - Course Detail View

struct CourseDetailView: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var progress: Double { vm.progressInCourse(course) }

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
                    Text(course.level.japanese)
                        .modernPill(color: course.level.modernColor)
                    Spacer()
                    // Spacer placeholder for balance
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
                    VStack(alignment: .leading, spacing: 20) {
                        // Course Hero
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(course.level.modernGradient)
                                        .frame(width: 64, height: 64)
                                    Text(course.emoji)
                                        .font(.system(size: 34))
                                }
                                .shadow(color: course.level.modernColor.opacity(0.3), radius: 10, x: 0, y: 4)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(course.title)
                                        .font(ModernFont.headlineLarge)
                                        .foregroundColor(ModernTheme.textPrimary)
                                    Text(course.subtitle)
                                        .font(ModernFont.bodySmall)
                                        .foregroundColor(ModernTheme.textSecondary)
                                }
                            }

                            Text(course.description)
                                .font(ModernFont.bodyMedium)
                                .foregroundColor(ModernTheme.textSecondary)
                                .lineSpacing(4)

                            // Stats
                            HStack(spacing: 20) {
                                StatBadge(icon: "book.closed.fill", text: "\(course.totalLessons) レッスン", color: course.level.modernColor)
                                StatBadge(icon: "clock.fill", text: "\(course.estimatedMinutes)分", color: course.level.modernColor)
                                Spacer()
                            }

                            // Progress
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("進捗")
                                        .font(ModernFont.labelMedium)
                                        .foregroundColor(ModernTheme.textSecondary)
                                    Spacer()
                                    Text("\(Int(progress * 100))%")
                                        .font(ModernFont.labelLarge)
                                        .foregroundColor(course.level.modernColor)
                                }
                                ProgressBarView(
                                    progress: progress,
                                    tint: course.level.modernColor,
                                    track: ModernTheme.bgSubtle
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(ModernTheme.bgCard)
                        )
                        .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                        // Chapters
                        ForEach(course.chapters) { chapter in
                            ChapterSection(chapter: chapter, course: course, vm: vm)
                                .padding(.horizontal, 20)
                        }

                        Spacer(minLength: 24)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StatBadge: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(ModernFont.labelMedium)
        }
        .foregroundColor(color)
    }
}

// MARK: - Chapter Section

struct ChapterSection: View {
    let chapter: Chapter
    let course: Course
    @ObservedObject var vm: AppViewModel

    var completedCount: Int {
        chapter.lessons.filter { vm.isLessonCompleted($0) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                // Chapter number badge
                ZStack {
                    Circle()
                        .fill(course.level.modernSoft)
                        .frame(width: 38, height: 38)
                    Text("\(chapter.number)")
                        .font(ModernFont.headlineMedium)
                        .foregroundColor(course.level.modernColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(chapter.title)
                        .font(ModernFont.headlineSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                    Text(chapter.summary)
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
                if completedCount == chapter.lessons.count && chapter.lessons.count > 0 {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(ModernTheme.success)
                        .font(.system(size: 22))
                } else {
                    Text("\(completedCount)/\(chapter.lessons.count)")
                        .font(ModernFont.labelMedium)
                        .foregroundColor(ModernTheme.textTertiary)
                }
            }

            VStack(spacing: 8) {
                ForEach(chapter.lessons) { lesson in
                    LessonRow(lesson: lesson, course: course, vm: vm)
                }
            }
        }
        .padding(16)
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

// MARK: - Lesson Row

struct LessonRow: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel

    var isCompleted: Bool { vm.isLessonCompleted(lesson) }

    var body: some View {
        Button(action: { vm.navigateToLesson(lesson, in: course) }) {
            HStack(spacing: 12) {
                // Lesson icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isCompleted ? ModernTheme.successSoft : ModernTheme.bgSubtle)
                        .frame(width: 42, height: 42)
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ModernTheme.success)
                    } else {
                        Text(lesson.emoji)
                            .font(.system(size: 20))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(ModernFont.bodyEmphasizedSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: lesson.content.typeIcon)
                                .font(.system(size: 10, weight: .semibold))
                            Text(lesson.content.typeLabel)
                                .font(ModernFont.labelSmall)
                        }
                        .foregroundColor(course.level.modernColor)

                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text("\(lesson.estimatedMinutes)分")
                                .font(ModernFont.labelSmall)
                        }
                        .foregroundColor(ModernTheme.textTertiary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ModernTheme.textTertiary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCompleted ? ModernTheme.successSoft.opacity(0.4) : ModernTheme.bgSubtle.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Lesson View (Complex - Handles all lesson types)

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

                        // Flow indicator: 学習 → 問題 → 確認
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

                    // Ad banner (modern, light)
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

enum LessonTab {
    case learning
    case problem
}

// MARK: - Lesson Flow Indicator

struct LessonFlowIndicator: View {
    let currentTab: LessonTab
    let isCompleted: Bool
    let color: Color

    var body: some View {
        HStack(spacing: 0) {
            FlowStep(
                icon: "book.fill",
                label: "学習",
                isActive: currentTab == .learning,
                isDone: currentTab == .problem || isCompleted,
                color: color
            )

            FlowConnector(isActive: currentTab == .problem || isCompleted, color: color)

            FlowStep(
                icon: "target",
                label: "問題",
                isActive: currentTab == .problem,
                isDone: isCompleted,
                color: color
            )

            FlowConnector(isActive: isCompleted, color: color)

            FlowStep(
                icon: "checkmark",
                label: "完了",
                isActive: false,
                isDone: isCompleted,
                color: ModernTheme.success
            )
        }
    }
}

struct FlowStep: View {
    let icon: String
    let label: String
    let isActive: Bool
    let isDone: Bool
    let color: Color

    var fillColor: Color {
        if isDone { return color }
        if isActive { return color }
        return ModernTheme.bgSubtle
    }

    var iconColor: Color {
        if isDone || isActive { return .white }
        return ModernTheme.textTertiary
    }

    var labelColor: Color {
        if isActive { return color }
        if isDone { return ModernTheme.textPrimary }
        return ModernTheme.textTertiary
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 36, height: 36)
                if isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(iconColor)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }
            .shadow(
                color: (isActive || isDone) ? color.opacity(0.3) : Color.clear,
                radius: 6, x: 0, y: 2
            )

            Text(label)
                .font(ModernFont.labelSmall)
                .foregroundColor(labelColor)
                .fontWeight(isActive ? .semibold : .regular)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FlowConnector: View {
    let isActive: Bool
    let color: Color

    var body: some View {
        Rectangle()
            .fill(isActive ? color : ModernTheme.borderStrong)
            .frame(height: 2)
            .padding(.bottom, 22) // align with circle center
            .padding(.horizontal, -4)
    }
}

struct TabSelectorButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(label)
                    .font(ModernFont.bodyEmphasizedSmall)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color : ModernTheme.bgSubtle)
            )
            .foregroundColor(isSelected ? .white : ModernTheme.textSecondary)
            .shadow(
                color: isSelected ? color.opacity(0.3) : Color.clear,
                radius: 8, x: 0, y: 3
            )
        }
    }
}

struct LessonLearningTabView: View {
    let lesson: Lesson
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section title
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

// MARK: - Concept Lesson View

struct ConceptLessonView: View {
    let concept: ConceptLesson
    var course: Course? = nil

    var accentColor: Color {
        course?.level.modernColor ?? ModernTheme.primary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(concept.headline)
                .font(ModernFont.headlineLarge)
                .foregroundColor(ModernTheme.textPrimary)
                .padding(.horizontal, 20)

            VStack(spacing: 14) {
                ForEach(concept.sections) { section in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(section.heading)
                            .font(ModernFont.headlineSmall)
                            .foregroundColor(ModernTheme.textPrimary)

                        Text(section.body)
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textSecondary)
                            .lineSpacing(6)

                        if let code = section.codeSample {
                            CodeBlock(text: code, accent: accentColor)
                        }

                        if let tip = section.tip {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(ModernTheme.warning)
                                Text(tip)
                                    .font(ModernFont.bodySmall)
                                    .foregroundColor(ModernTheme.textPrimary)
                                    .lineSpacing(4)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ModernTheme.warningSoft.opacity(0.5))
                            )
                        }
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
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Code Block (modern, dark-on-light)

struct CodeBlock: View {
    let text: String
    var accent: Color = ModernTheme.primary

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("$")
                .font(ModernFont.codeMedium)
                .foregroundColor(accent)
            Text(text)
                .font(ModernFont.codeMedium)
                .foregroundColor(ModernTheme.codeText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ModernTheme.codeBg)
        )
    }
}

// MARK: - Quest Lesson View

struct QuestLessonView: View {
    let quest: QuestLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    @State private var showCompletion = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Scenario card
            LearningSectionCard(
                title: "シナリオ",
                icon: "quote.bubble.fill",
                color: course.level.modernColor
            ) {
                Text(quest.scenario)
                    .font(ModernFont.bodyMedium)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineSpacing(5)
            }

            // Prompt card
            LearningSectionCard(
                title: "問題",
                icon: "questionmark.circle.fill",
                color: ModernTheme.secondary
            ) {
                Text(quest.prompt)
                    .font(ModernFont.bodyLarge)
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineSpacing(5)
            }

            // Hint
            HintBlock(text: quest.hint, isShown: vm.showHint) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    vm.showHint.toggle()
                }
            }

            // Terminal Panel
            TerminalPanel(
                input: vm.userInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                successMessage: quest.successMessage
            )

            // Command options
            VStack(spacing: 10) {
                Text("コマンドを選択")
                    .font(ModernFont.labelMedium)
                    .foregroundColor(ModernTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 8) {
                    ForEach(quest.options) { option in
                        CommandButton(
                            option: option,
                            accentColor: course.level.modernColor,
                            isSelected: vm.userInput == option.command,
                            isDisabled: vm.currentLessonState != .waiting
                        ) {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            vm.selectCommand(option)
                        }
                    }
                }
            }

            // Execute / Retry / Complete buttons
            HStack(spacing: 10) {
                if vm.currentLessonState == .wrong {
                    PrimaryActionButton(
                        title: "もう一度",
                        icon: "arrow.counterclockwise",
                        style: .secondary
                    ) {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        vm.retry()
                    }
                }

                if vm.currentLessonState != .correct && vm.currentLessonState != .completed {
                    PrimaryActionButton(
                        title: "実行",
                        icon: "play.fill",
                        style: .primary,
                        color: course.level.modernColor,
                        disabled: vm.userInput.isEmpty
                    ) {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        vm.executeQuest(quest)
                    }
                }

                if vm.currentLessonState == .correct {
                    PrimaryActionButton(
                        title: "完了",
                        icon: "checkmark.circle.fill",
                        style: .success
                    ) {
                        let impact = UINotificationFeedbackGenerator()
                        impact.notificationOccurred(.success)
                        showCompletion = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            vm.completeLesson(lesson)
                            vm.goBack()
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, 20)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.currentLessonState)
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
    }
}

// MARK: - Hint Block

struct HintBlock: View {
    let text: String
    let isShown: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: toggle) {
                HStack(spacing: 8) {
                    Image(systemName: isShown ? "lightbulb.fill" : "lightbulb")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ModernTheme.warning)
                    Text(isShown ? "ヒントを隠す" : "ヒントを見る")
                        .font(ModernFont.bodyEmphasizedSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                    Spacer()
                    Image(systemName: isShown ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ModernTheme.textTertiary)
                }
                .padding(14)
            }

            if isShown {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(ModernTheme.warning)
                        .font(.system(size: 14))
                    Text(text)
                        .font(ModernFont.bodyMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineSpacing(4)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Rectangle().fill(ModernTheme.warningSoft.opacity(0.4))
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ModernTheme.warning.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Primary Action Button

enum ActionStyle {
    case primary
    case secondary
    case success
    case danger
}

struct PrimaryActionButton: View {
    let title: String
    let icon: String
    var style: ActionStyle = .primary
    var color: Color = ModernTheme.primary
    var disabled: Bool = false
    let action: () -> Void

    var fillColor: Color {
        if disabled { return ModernTheme.borderStrong }
        switch style {
        case .primary: return color
        case .secondary: return ModernTheme.bgSubtle
        case .success: return ModernTheme.success
        case .danger: return ModernTheme.danger
        }
    }

    var foregroundColor: Color {
        if disabled { return .white }
        switch style {
        case .primary, .success, .danger: return .white
        case .secondary: return ModernTheme.textPrimary
        }
    }

    var shadowColor: Color {
        if disabled { return .clear }
        switch style {
        case .primary: return color.opacity(0.35)
        case .success: return ModernTheme.success.opacity(0.35)
        case .danger: return ModernTheme.danger.opacity(0.35)
        case .secondary: return .clear
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                Text(title)
                    .font(ModernFont.bodyEmphasized)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(fillColor)
            )
            .foregroundColor(foregroundColor)
            .shadow(color: shadowColor, radius: 10, x: 0, y: 4)
        }
        .disabled(disabled)
    }
}

// MARK: - Terminal Panel (Modern Light)

struct TerminalPanel: View {
    let input: String
    let output: String
    let state: LessonState
    let successMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Terminal header bar
            HStack(spacing: 8) {
                Circle().fill(Color(hex: 0xFF5F57)).frame(width: 10, height: 10)
                Circle().fill(Color(hex: 0xFEBC2E)).frame(width: 10, height: 10)
                Circle().fill(Color(hex: 0x28C840)).frame(width: 10, height: 10)
                Spacer()
                Text("terminal")
                    .font(ModernFont.codeSmall)
                    .foregroundColor(Color.white.opacity(0.5))
                Spacer()
                Color.clear.frame(width: 38, height: 1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: 0x0F172A))

            // Terminal body
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text("user@linatex")
                                .foregroundColor(Color(hex: 0x10B981))
                                .font(ModernFont.codeSmall)
                            Text(":")
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(ModernFont.codeSmall)
                            Text("~")
                                .foregroundColor(Color(hex: 0x60A5FA))
                                .font(ModernFont.codeSmall)
                            Text("$")
                                .foregroundColor(Color.white.opacity(0.7))
                                .font(ModernFont.codeSmall)
                            Text(input)
                                .foregroundColor(.white)
                                .font(ModernFont.codeSmall)
                            if state == .waiting {
                                CursorView()
                            }
                            Spacer()
                        }
                        .id("input")

                        if !output.isEmpty {
                            Text(output)
                                .font(ModernFont.codeSmall)
                                .foregroundColor(Color.white.opacity(0.85))
                                .lineSpacing(2)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id("output")
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .onChange(of: output) { _ in
                        withAnimation { proxy.scrollTo("output", anchor: .bottom) }
                    }
                    .onChange(of: state) { _ in
                        if state == .correct {
                            withAnimation { proxy.scrollTo("success", anchor: .bottom) }
                        } else if state == .wrong {
                            withAnimation { proxy.scrollTo("error", anchor: .bottom) }
                        }
                    }
                }
            }
            .frame(minHeight: 160)
            .background(Color(hex: 0x1E293B))
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: ModernTheme.shadowColorMedium, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Cursor

struct CursorView: View {
    @State private var visible = true
    var body: some View {
        Rectangle()
            .fill(Color(hex: 0x10B981))
            .frame(width: 8, height: 14)
            .opacity(visible ? 0.9 : 0.2)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.55).repeatForever()) {
                    visible.toggle()
                }
            }
    }
}

// MARK: - Command Button (Modern Light)

struct CommandButton: View {
    let option: CommandOption
    let accentColor: Color
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? accentColor : ModernTheme.borderStrong, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 12, height: 12)
                    }
                }

                Text(option.label)
                    .font(ModernFont.codeMedium)
                    .foregroundColor(ModernTheme.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? accentColor.opacity(0.08) : ModernTheme.bgCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? accentColor : ModernTheme.border,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.55 : 1.0)
    }
}

// MARK: - Color Extensions

extension Color {
    static var transparent: Color {
        Color.white.opacity(0)
    }
}

// MARK: - Use implemented views from LessonImplementations.swift

typealias ScenarioLessonView = ScenarioLessonViewImpl
typealias QuizLessonView = QuizLessonViewImpl

#Preview {
    ContentView()
}
