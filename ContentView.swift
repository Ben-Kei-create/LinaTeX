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
        .preferredColorScheme(.dark)
    }
}

// MARK: - Home View

struct HomeView: View {
    @ObservedObject var vm: AppViewModel
    @State private var selectedCourse: Course?

    var body: some View {
        ZStack {
            TerminalTheme.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🐧 LinaTeX")
                                .font(.system(.title2, design: .monospaced))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Learn Linux by Playing")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(TerminalTheme.textSecondary)
                                    Text("\(vm.totalXP) XP")
                                        .font(.system(.subheadline, design: .monospaced))
                                        .fontWeight(.semibold)
                                }

                                NavigationLink(destination: StatisticsView(vm: vm)) {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(TerminalTheme.greenPrimary)
                                        .font(.system(size: 14))
                                }

                                NavigationLink(destination: AchievementsView(vm: vm)) {
                                    Image(systemName: "star.circle.fill")
                                        .foregroundColor(TerminalTheme.textSecondary)
                                        .font(.system(size: 14))
                                }
                            }
                            ProgressView(value: vm.totalProgress())
                                .frame(width: 100)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(TerminalTheme.bgSecondary)

                ScrollView {
                    VStack(spacing: 16) {
                        // AI Recommendation
                        PersonalizedRecommendationView(vm: vm) { lesson in
                            if let course = vm.courses.first(where: { course in
                                course.chapters.contains { chapter in
                                    chapter.lessons.contains { $0.id == lesson.id }
                                }
                            }) {
                                vm.navigateToLesson(lesson, in: course)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                        Text("コースを選択")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)

                        ForEach(vm.courses) { course in
                            CourseCard(course: course, vm: vm)
                                .onTapGesture {
                                    vm.navigateToCourse(course)
                                }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Course Card

struct CourseCard: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(course.emoji)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(course.level.japanese.uppercased())
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(course.level.mainColor)
                        .fontWeight(.bold)

                    Text(course.title)
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.white)

                    Text(course.subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .font(.caption)
                        Text("\(course.totalLessons)")
                            .font(.system(.caption, design: .monospaced))
                    }
                    .foregroundColor(.white.opacity(0.7))

                    ProgressView(value: vm.progressInCourse(course))
                        .frame(width: 60)
                        .tint(course.level.mainColor)
                }
            }

            Text(course.description)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
                .lineSpacing(2)

            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.caption2)
                Text("\(course.estimatedMinutes)分で修了")
                    .font(.system(.caption2, design: .monospaced))
            }
            .foregroundColor(.white.opacity(0.5))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(TerminalTheme.bgTertiary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(course.level.mainColor.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Course Detail View

struct CourseDetailView: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        ZStack {
            TerminalTheme.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { vm.goBack() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(.body, design: .monospaced))
                            Text("戻る")
                                .font(.system(.subheadline, design: .monospaced))
                        }
                        .foregroundColor(course.level.mainColor)
                    }
                    Spacer()
                    Text(course.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(16)
                .background(TerminalTheme.bgSecondary)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(course.chapters) { chapter in
                            ChapterSection(chapter: chapter, course: course, vm: vm)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Chapter Section

struct ChapterSection: View {
    let chapter: Chapter
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("第\(chapter.number)章")
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(course.level.mainColor)
                        .fontWeight(.bold)
                    Text(chapter.title)
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.white)
                    Text(chapter.summary)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
            }

            VStack(spacing: 8) {
                ForEach(chapter.lessons) { lesson in
                    LessonRow(lesson: lesson, course: course, vm: vm)
                }
            }
        }
        .padding(14)
        .background(TerminalTheme.bgTertiary)
        .cornerRadius(10)
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
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        if isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                        Text(lesson.emoji)
                        Text(lesson.title)
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 8) {
                        Label(lesson.content.typeLabel, systemImage: lesson.content.typeIcon)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(course.level.mainColor)

                        Label("\(lesson.estimatedMinutes)分", systemImage: "clock.fill")
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .padding(10)
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

// MARK: - Lesson View (Complex - Handles all lesson types)

struct LessonView: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    @State private var selectedTab: LessonTab = .problem

    var body: some View {
        ZStack {
            TerminalTheme.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with back button
                HStack {
                    Button(action: { vm.goBack() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(course.level.mainColor)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: lesson.content.typeIcon)
                        Text(lesson.content.typeLabel)
                    }
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(course.level.mainColor)
                    .fontWeight(.bold)
                }
                .padding(14)
                .background(TerminalTheme.bgSecondary)

                ScrollView {
                    VStack(spacing: 16) {
                        // Lesson Header
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                Text(lesson.emoji)
                                    .font(.system(size: 36))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lesson.title)
                                        .font(.system(.headline, design: .monospaced))
                                        .foregroundColor(.white)
                                    HStack(spacing: 8) {
                                        Image(systemName: "clock.fill")
                                            .font(.caption2)
                                        Text("\(lesson.estimatedMinutes)分")
                                            .font(.system(.caption, design: .monospaced))
                                    }
                                    .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        .padding(16)
                        .background(TerminalTheme.bgTertiary)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)

                        // Content based on selected tab
                        if selectedTab == .learning {
                            LessonLearningTabView(lesson: lesson)
                        } else {
                            // Problem-solving content based on lesson type
                            switch lesson.content {
                            case .concept(let concept):
                                ConceptLessonView(concept: concept)
                            case .quest(let quest):
                                QuestLessonView(quest: quest, course: course, vm: vm, lesson: lesson)
                            case .scenario(let scenario):
                                ScenarioLessonView(scenario: scenario, course: course, vm: vm, lesson: lesson)
                            case .quiz(let quiz):
                                QuizLessonView(quiz: quiz, course: course, vm: vm, lesson: lesson)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }

                // Tab selector
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        TabSelectorButton(
                            icon: "book.fill",
                            label: "学習",
                            isSelected: selectedTab == .learning,
                            color: course.level.mainColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = .learning
                            }
                        }

                        TabSelectorButton(
                            icon: "target",
                            label: "問題",
                            isSelected: selectedTab == .problem,
                            color: course.level.mainColor
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = .problem
                            }
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(TerminalTheme.bgSecondary)

                    // Ad banner
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("広告")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(TerminalTheme.textTertiary)
                            Text("LinaTeX Pro - より多くのコースをアンロック")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(TerminalTheme.textTertiary)
                    }
                    .padding(12)
                    .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                    .cornerRadius(6)
                    .padding(12)
                }
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

struct TabSelectorButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(label)
            }
            .font(.system(.caption, design: .monospaced))
            .fontWeight(.semibold)
            .padding(10)
            .background(isSelected ? color.opacity(0.2) : Color.transparent)
            .foregroundColor(isSelected ? color : .white.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? color : Color.transparent, lineWidth: 1)
            )
            .cornerRadius(6)
        }
    }
}

struct LessonLearningTabView: View {
    let lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Generate learning material based on lesson content
            VStack(alignment: .leading, spacing: 12) {
                Text("📚 学習資料")
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(TerminalTheme.greenPrimary)

                Divider()
                    .background(TerminalTheme.borderColor)

                switch lesson.content {
                case .concept(let concept):
                    ConceptLessonView(concept: concept)

                case .scenario(let scenario):
                    VStack(alignment: .leading, spacing: 12) {
                        Text("シナリオの概要")
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(scenario.setup)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(2)

                        Text("目標")
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(TerminalTheme.greenSecondary)
                            .padding(.top, 8)

                        Text(scenario.goal)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(12)
                    .background(TerminalTheme.bgTertiary)
                    .cornerRadius(8)

                case .quest(let quest):
                    VStack(alignment: .leading, spacing: 12) {
                        Text("クエストの内容")
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text(quest.scenario)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(2)

                        Text("プロンプト")
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(TerminalTheme.greenSecondary)
                            .padding(.top, 8)

                        Text(quest.prompt)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(12)
                    .background(TerminalTheme.bgTertiary)
                    .cornerRadius(8)

                case .quiz(let quiz):
                    VStack(alignment: .leading, spacing: 12) {
                        Text("クイズについて")
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("全\(quiz.questions.count)問のクイズが出題されます。各問題を丁寧に読んで、正しい選択肢を選んでください。")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(2)

                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(TerminalTheme.accentYellow)
                                .font(.caption)

                            Text("間違えてもその場で解説を確認できます")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(TerminalTheme.accentYellow)
                        }
                        .padding(10)
                        .background(TerminalTheme.accentYellow.opacity(0.1))
                        .cornerRadius(6)
                    }
                    .padding(12)
                    .background(TerminalTheme.bgTertiary)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Concept Lesson View

struct ConceptLessonView: View {
    let concept: ConceptLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(concept.headline)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(TerminalTheme.greenPrimary)
                .padding(.horizontal, 16)

            ForEach(concept.sections) { section in
                VStack(alignment: .leading, spacing: 10) {
                    Text(section.heading)
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(section.body)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                        .lineSpacing(3)

                    if let code = section.codeSample {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("$ \(code)")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.green)
                        }
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(6)
                    }

                    if let tip = section.tip {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .font(.caption)
                                .foregroundColor(TerminalTheme.textSecondary)
                            Text(tip)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.yellow.opacity(0.9))
                        }
                        .padding(8)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
                .padding(12)
                .background(TerminalTheme.bgTertiary)
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
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
            // Scenario
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "quote.opening")
                        .foregroundColor(TerminalTheme.greenPrimary)
                        .font(.caption)
                    Text("シナリオ")
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(TerminalTheme.greenPrimary)
                }
                Text(quest.scenario)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .background(Color.cyan.opacity(0.1))
            .cornerRadius(8)

            // Prompt
            VStack(alignment: .leading, spacing: 8) {
                Text("📝 問題")
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(quest.prompt)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(12)
            .background(TerminalTheme.bgTertiary)
            .cornerRadius(8)

            // Hint Button
            Button(action: {
                withAnimation(.spring()) {
                    vm.showHint.toggle()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb\(vm.showHint ? ".fill" : "")")
                    Text(vm.showHint ? "ヒントを隠す" : "ヒント を見る")
                }
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(vm.showHint ? Color.yellow.opacity(0.2) : Color.white.opacity(0.05))
                .foregroundColor(vm.showHint ? .yellow : .white.opacity(0.6))
                .cornerRadius(6)
            }

            if vm.showHint {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(TerminalTheme.textSecondary)
                    Text(quest.hint)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(TerminalTheme.textSecondary)
                }
                .padding(10)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(6)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Terminal Output (Fixed height)
            TerminalPanel(
                input: vm.userInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                successMessage: quest.successMessage
            )

            // Command Buttons
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(quest.options) { option in
                        CommandButton(
                            option: option,
                            accentColor: course.level.mainColor,
                            isSelected: vm.userInput == option.command,
                            isDisabled: vm.currentLessonState != .waiting
                        ) {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            vm.selectCommand(option)
                        }
                    }
                }

                // Execute / Retry / Next buttons
                HStack(spacing: 10) {
                    if vm.currentLessonState == .wrong {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            vm.retry()
                        }) {
                            Label("もう一度", systemImage: "arrow.counterclockwise")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.semibold)
                        }
                    }

                    if vm.currentLessonState != .correct && vm.currentLessonState != .completed {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .heavy)
                            impact.impactOccurred()
                            vm.executeQuest(quest)
                        }) {
                            Label("実行", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(vm.userInput.isEmpty ? Color.gray.opacity(0.2) : course.level.mainColor)
                                .foregroundColor(vm.userInput.isEmpty ? .gray : .black)
                                .cornerRadius(8)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.bold)
                        }
                        .disabled(vm.userInput.isEmpty)
                    }

                    if vm.currentLessonState == .correct {
                        Button(action: {
                            let impact = UINotificationFeedbackGenerator()
                            impact.notificationOccurred(.success)
                            showCompletion = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                vm.completeLesson(lesson)
                                vm.goBack()
                            }
                        }) {
                            Label("完了", systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(
                                    LinearGradient(
                                        colors: [course.level.mainColor, course.level.mainColor.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.bold)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
        .padding(16)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.currentLessonState)
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
    }
}

// MARK: - Terminal Panel (Fixed Layout)

struct TerminalPanel: View {
    let input: String
    let output: String
    let state: LessonState
    let successMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Terminal header
            HStack(spacing: 6) {
                Circle().fill(TerminalTheme.accentRed).frame(width: 6, height: 6)
                Circle().fill(TerminalTheme.accentYellow).frame(width: 6, height: 6)
                Circle().fill(TerminalTheme.greenSecondary).frame(width: 6, height: 6)
                Spacer()
                Text("— terminal").font(.system(.caption2, design: .monospaced)).foregroundColor(TerminalTheme.textTertiary)
            }
            .padding(8)
            .background(TerminalTheme.bgSecondary)
            .border(TerminalTheme.borderColor, width: 0.5)

            // Terminal output - scrollable
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        // Prompt and input at the top
                        HStack(spacing: 6) {
                            Text("fumiaki@linatex:~$")
                                .foregroundColor(TerminalTheme.greenPrimary)
                                .font(.system(.caption, design: .monospaced))
                            Text(input)
                                .foregroundColor(inputColor)
                                .font(.system(.caption, design: .monospaced))
                            if state == .waiting {
                                CursorView()
                            }
                            Spacer()
                        }
                        .id("input")

                        // Output
                        if !output.isEmpty {
                            Text(output)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(outputColor)
                                .lineSpacing(1)
                                .textSelection(.enabled)
                                .id("output")
                        }

                        // Feedback
                        if state == .correct {
                            HStack(spacing: 6) {
                                Text("✓")
                                    .foregroundColor(TerminalTheme.greenPrimary)
                                Text(successMessage)
                                    .font(.system(.caption2, design: .monospaced))
                                    .foregroundColor(TerminalTheme.greenSecondary)
                            }
                            .padding(.top, 4)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .id("success")
                        }

                        if state == .wrong {
                            Text("✗ コマンドが違います")
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(TerminalTheme.accentRed)
                                .padding(.top, 4)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .id("error")
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .onChange(of: output) { _ in
                        withAnimation {
                            proxy.scrollTo("output", anchor: .bottom)
                        }
                    }
                    .onChange(of: state) { _ in
                        if state == .correct {
                            withAnimation {
                                proxy.scrollTo("success", anchor: .bottom)
                            }
                        } else if state == .wrong {
                            withAnimation {
                                proxy.scrollTo("error", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .frame(minHeight: 140)
            .background(TerminalTheme.bgTertiary)
        }
        .background(TerminalTheme.bgPrimary)
        .border(TerminalTheme.borderColor, width: 1)
        .cornerRadius(4)
    }

    var inputColor: Color {
        switch state {
        case .correct: return TerminalTheme.greenPrimary
        case .wrong: return TerminalTheme.accentRed
        default: return TerminalTheme.textPrimary
        }
    }

    var outputColor: Color {
        state == .wrong ? TerminalTheme.accentRed : TerminalTheme.textSecondary
    }
}

// MARK: - Cursor

struct CursorView: View {
    @State private var visible = true
    var body: some View {
        Rectangle()
            .fill(TerminalTheme.greenPrimary)
            .frame(width: 6, height: 12)
            .opacity(visible ? 0.8 : 0.2)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                    visible.toggle()
                }
            }
    }
}

// MARK: - Command Button

struct CommandButton: View {
    let option: CommandOption
    let accentColor: Color
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(option.label)
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected
                            ? TerminalTheme.greenPrimary.opacity(0.15)
                            : TerminalTheme.bgTertiary
                        )
                )
                .border(isSelected ? TerminalTheme.greenPrimary : TerminalTheme.borderColor, width: 1)
                .foregroundColor(isSelected ? TerminalTheme.greenPrimary : TerminalTheme.textSecondary)
                .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

// MARK: - Use implemented views from LessonImplementations.swift

typealias ScenarioLessonView = ScenarioLessonViewImpl
typealias QuizLessonView = QuizLessonViewImpl

#Preview {
    ContentView()
}
