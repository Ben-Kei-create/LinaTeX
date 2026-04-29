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
                    case .chapter(let chapter, let course):
                        ThemeFlowView(
                            title: "第\(chapter.number)章 \(chapter.title)",
                            subtitle: course.level.japanese,
                            lessons: chapter.lessons,
                            course: course,
                            vm: vm
                        )
                    case .lesson(let lesson, let course):
                        LessonView(lesson: lesson, course: course, vm: vm)
                    case .home:
                        HomeView(vm: vm)
                    }
                }
        }
        .preferredColorScheme(.light)
        .tint(ModernTheme.emeraldPrimary)
    }
}

// MARK: - Shared Shell UI

struct ShellScreen<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            ModernTheme.background.ignoresSafeArea()
            LinearGradient(
                colors: [
                    ModernTheme.bluePrimary.opacity(0.13),
                    ModernTheme.emeraldSecondary.opacity(0.09),
                    ModernTheme.background.opacity(0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            content
        }
    }
}

struct ScanlineOverlay: View {
    var body: some View {
        GeometryReader { proxy in
            let rows = Int(proxy.size.height / 6)

            VStack(spacing: 5) {
                ForEach(0..<max(rows, 1), id: \.self) { _ in
                    Rectangle()
                        .fill(ModernTheme.bluePrimary.opacity(0.025))
                        .frame(height: 1)
                }
            }
        }
    }
}

struct ShellPanel<Content: View>: View {
    var borderOpacity: Double = 0.2
    var cornerRadius: CGFloat = ModernTheme.cardRadius
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(ModernTheme.bgSecondary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(ModernTheme.borderColor.opacity(min(0.95, 0.62 + borderOpacity)), lineWidth: 1)
            )
            .shadow(color: ModernTheme.cardShadow, radius: 16, x: 0, y: 8)
    }
}

struct ShellHeader: View {
    let title: String
    let subtitle: String
    var trailing: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(ModernTheme.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(ModernTheme.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 10)

            if let trailing {
                if let action {
                    Button(trailing, action: action)
                        .buttonStyle(ShellButtonStyle(kind: .outline))
                } else {
                    ShellStatusText(trailing)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ModernTheme.bgPrimary.opacity(0.94))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(ModernTheme.borderColor)
                .frame(height: 1)
        }
    }
}

struct ShellStatusText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .shellFont(.caption, weight: .semibold)
            .foregroundColor(ModernTheme.emeraldPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                    .fill(ModernTheme.emeraldSoft.opacity(0.72))
            )
            .overlay(
                RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                    .stroke(ModernTheme.emeraldPrimary.opacity(0.18), lineWidth: 1)
            )
    }
}

enum ShellButtonKind {
    case outline
    case filled
    case dim
}

struct ShellButtonStyle: ButtonStyle {
    var kind: ShellButtonKind = .outline
    var isSelected = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shellFont(.caption, weight: .bold)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.76)
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .frame(minHeight: 50)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                        .fill(backgroundColor(isPressed: configuration.isPressed))

                    if kind == .filled || isSelected {
                        RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        ModernTheme.bluePrimary.opacity(configuration.isPressed ? 0.88 : 1),
                                        ModernTheme.emeraldPrimary.opacity(configuration.isPressed ? 0.88 : 1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                    .stroke(borderColor(isPressed: configuration.isPressed), lineWidth: isSelected || kind == .filled ? 2 : 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }

    private var foregroundColor: Color {
        switch kind {
        case .filled:
            return ModernTheme.textOnAccent
        case .outline, .dim:
            return isSelected ? ModernTheme.textOnAccent : ModernTheme.textPrimary
        }
    }

    private func backgroundColor(isPressed: Bool) -> Color {
        if kind == .filled {
            return ModernTheme.emeraldPrimary.opacity(isPressed ? 0.82 : 1)
        }

        if isSelected {
            return ModernTheme.emeraldPrimary.opacity(isPressed ? 0.82 : 1)
        }

        switch kind {
        case .dim:
            return ModernTheme.bgTertiary.opacity(isPressed ? 0.98 : 0.76)
        default:
            return ModernTheme.bgSecondary.opacity(isPressed ? 1 : 0.92)
        }
    }

    private func borderColor(isPressed: Bool) -> Color {
        if kind == .filled {
            return ModernTheme.emeraldPrimary
        }
        return isSelected || isPressed ? ModernTheme.emeraldPrimary : ModernTheme.borderColor
    }
}

struct ShellCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

struct ShellProgressBar: View {
    let value: Double
    var height: CGFloat = 8

    var clampedValue: Double {
        min(max(value, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(ModernTheme.bgTertiary)
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [ModernTheme.bluePrimary, ModernTheme.emeraldPrimary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: proxy.size.width * clampedValue)
                    .animation(.spring(response: 0.45, dampingFraction: 0.82), value: clampedValue)
            }
            .overlay(
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .stroke(ModernTheme.borderColor, lineWidth: 1)
            )
        }
        .frame(height: height)
    }
}

struct ShellMetric: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value.uppercased())
                .shellFont(.headline, weight: .bold)
                .foregroundColor(ModernTheme.emeraldPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text(label.uppercased())
                .shellFont(.caption2)
                .foregroundColor(ModernTheme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                .fill(ModernTheme.bgTertiary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                .stroke(ModernTheme.borderColor, lineWidth: 1)
        )
    }
}

struct ShellSectionTitle: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .shellFont(.caption, weight: .bold)
                .foregroundColor(ModernTheme.bluePrimary)

            if let subtitle {
                Text(subtitle)
                    .shellFont(.caption2)
                    .foregroundColor(ModernTheme.textTertiary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

enum AdPlacement {
    case home
    case courseDetail
    case themeComplete

    var caption: String {
        switch self {
        case .home:
            return "Linux学習に役立つ情報"
        case .courseDetail:
            return "コースに関連するおすすめ"
        case .themeComplete:
            return "テーマ完了後のおすすめ"
        }
    }
}

struct AdSlotView: View {
    let placement: AdPlacement

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "megaphone.fill")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(ModernTheme.bluePrimary)
                .frame(width: 34, height: 34)
                .background(
                    RoundedRectangle(cornerRadius: ModernTheme.buttonRadius, style: .continuous)
                        .fill(ModernTheme.blueSoft.opacity(0.72))
                )

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("広告")
                        .shellFont(.caption2, weight: .bold)
                        .foregroundColor(ModernTheme.textTertiary)

                    Text(placement.caption)
                        .shellFont(.caption2)
                        .foregroundColor(ModernTheme.textTertiary)
                        .lineLimit(1)
                }

                Text("スポンサーコンテンツ")
                    .shellFont(.caption)
                    .foregroundColor(ModernTheme.textSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 70, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ModernTheme.cardRadius, style: .continuous)
                .fill(ModernTheme.bgSecondary.opacity(0.82))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ModernTheme.cardRadius, style: .continuous)
                .stroke(ModernTheme.borderColor, lineWidth: 1)
        )
    }
}

extension View {
    func shellFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> some View {
        font(.system(style, design: .rounded).weight(weight))
    }
}

// MARK: - Home View

struct HomeView: View {
    @ObservedObject var vm: AppViewModel

    private var totalPercent: String {
        String(format: "%.0f%%", vm.totalProgress() * 100)
    }

    var body: some View {
        ShellScreen {
            VStack(spacing: 0) {
                ShellHeader(
                    title: "LinaTeX",
                    subtitle: "Linuxを実務で実践",
                    trailing: nil
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        ShellPanel {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("TOTAL")
                                        .shellFont(.caption, weight: .bold)
                                        .foregroundColor(TerminalTheme.textSecondary)
                                    Spacer()
                                    Text(totalPercent)
                                        .shellFont(.largeTitle, weight: .bold)
                                        .foregroundColor(TerminalTheme.greenPrimary)
                                }

                                ShellProgressBar(value: vm.totalProgress(), height: 10)
                            }
                        }

                        Button {
                            vm.navigateToCommandDictionary()
                        } label: {
                            ShellPanel(borderOpacity: 0.28, cornerRadius: TerminalTheme.buttonRadius) {
                                HStack(alignment: .center, spacing: 12) {
                                    Image(systemName: "book.closed.fill")
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(TerminalTheme.bluePrimary)
                                        .frame(width: 34)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Linuxコマンド辞典")
                                            .shellFont(.headline, weight: .bold)
                                            .foregroundColor(TerminalTheme.textPrimary)
                                        Text("基本、ファイル操作、検索、権限、通信をすぐ確認")
                                            .shellFont(.caption)
                                            .foregroundColor(TerminalTheme.textSecondary)
                                            .lineLimit(2)
                                    }

                                    Spacer(minLength: 8)

                                    Text("開く")
                                        .shellFont(.caption, weight: .bold)
                                        .foregroundColor(TerminalTheme.textOnAccent)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [TerminalTheme.bluePrimary, TerminalTheme.emeraldPrimary],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        )
                                }
                            }
                        }
                        .buttonStyle(ShellCardButtonStyle())

                        ShellSectionTitle(title: "コースを選ぶ")

                        VStack(spacing: 10) {
                            ForEach(Array(vm.courses.enumerated()), id: \.element.id) { index, course in
                                CourseCard(index: index + 1, course: course, vm: vm)
                            }
                        }

                        AdSlotView(placement: .home)
                    }
                    .padding(16)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Course Card

struct CourseCard: View {
    let index: Int
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        Button {
            vm.navigateToCourse(course)
        } label: {
            ShellPanel(borderOpacity: 0.3, cornerRadius: TerminalTheme.buttonRadius) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
                        Text(String(format: "%02d", index))
                            .shellFont(.title3, weight: .bold)
                            .foregroundColor(TerminalTheme.greenPrimary)
                            .frame(width: 44, alignment: .leading)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(course.level.japanese.uppercased())
                                .shellFont(.caption2, weight: .bold)
                                .foregroundColor(TerminalTheme.textTertiary)

                            Text(course.title)
                                .shellFont(.headline, weight: .bold)
                                .foregroundColor(TerminalTheme.textPrimary)
                                .lineLimit(2)
                                .minimumScaleFactor(0.82)

                            Text(course.subtitle)
                                .shellFont(.caption)
                                .foregroundColor(TerminalTheme.textSecondary)
                                .lineLimit(2)
                        }

                        Spacer(minLength: 8)

                        Text("開始")
                            .shellFont(.caption, weight: .bold)
                            .foregroundColor(TerminalTheme.textOnAccent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [course.level.gradient.first ?? TerminalTheme.bluePrimary, course.level.gradient.last ?? TerminalTheme.emeraldPrimary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .lineLimit(1)
                    }

                    Text(course.description)
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.textSecondary)
                        .lineSpacing(3)
                        .lineLimit(4)

                }
            }
        }
        .buttonStyle(ShellCardButtonStyle())
    }
}

// MARK: - Course Detail View

struct CourseDetailView: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        ShellScreen {
            VStack(spacing: 0) {
                ShellHeader(
                    title: course.title,
                    subtitle: course.level.japanese,
                    trailing: "< BACK",
                    action: {
                        vm.goBack()
                    }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CourseProgressPanel(course: course, vm: vm)

                        ShellSectionTitle(title: "チャプター")

                        ForEach(course.chapters) { chapter in
                            ChapterSection(chapter: chapter, course: course, vm: vm)
                        }

                        AdSlotView(placement: .courseDetail)
                    }
                    .padding(16)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CourseProgressPanel: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    private var completedCount: Int {
        course.chapters.reduce(0) { total, chapter in
            total + chapter.lessons.filter { vm.isLessonCompleted($0) }.count
        }
    }

    private var totalCount: Int {
        course.totalLessons
    }

    private var progress: Double {
        vm.progressInCourse(course)
    }

    private var percentText: String {
        String(format: "%.0f%%", progress * 100)
    }

    var body: some View {
        ShellPanel(borderOpacity: 0.26, cornerRadius: TerminalTheme.buttonRadius) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text("COURSE PROGRESS")
                        .shellFont(.caption, weight: .bold)
                        .foregroundColor(TerminalTheme.textSecondary)

                    Spacer()

                    Text(percentText)
                        .shellFont(.title2, weight: .bold)
                        .foregroundColor(TerminalTheme.greenPrimary)
                }

                ShellProgressBar(value: progress, height: 9)

                Text("\(completedCount) / \(totalCount) テーマ完了")
                    .shellFont(.caption)
                    .foregroundColor(TerminalTheme.textSecondary)
            }
        }
    }
}

// MARK: - Chapter Section

struct ChapterSection: View {
    let chapter: Chapter
    let course: Course
    @ObservedObject var vm: AppViewModel

    private var completedCount: Int {
        chapter.lessons.filter { vm.isLessonCompleted($0) }.count
    }

    private var progress: Double {
        chapter.lessons.isEmpty ? 0 : Double(completedCount) / Double(chapter.lessons.count)
    }

    var body: some View {
        Button {
            vm.navigateToChapter(chapter, in: course)
        } label: {
            ShellPanel(borderOpacity: 0.3, cornerRadius: TerminalTheme.buttonRadius) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
                        Text(String(format: "%02d", chapter.number))
                            .shellFont(.title3, weight: .bold)
                            .foregroundColor(TerminalTheme.greenPrimary)
                            .frame(width: 44, alignment: .leading)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(chapter.title)
                                .shellFont(.headline, weight: .bold)
                                .foregroundColor(TerminalTheme.textPrimary)
                                .lineLimit(2)

                            Text("\(chapter.lessons.count) THEMES")
                                .shellFont(.caption2, weight: .bold)
                                .foregroundColor(TerminalTheme.textTertiary)
                        }

                        Spacer(minLength: 8)

                        Text("開く")
                            .shellFont(.caption, weight: .bold)
                            .foregroundColor(TerminalTheme.textOnAccent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [TerminalTheme.bluePrimary, TerminalTheme.emeraldPrimary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .lineLimit(1)
                    }

                    Text(chapter.summary)
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.textSecondary)
                        .lineSpacing(3)
                        .lineLimit(3)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("\(completedCount) / \(chapter.lessons.count) 完了")
                                .shellFont(.caption2, weight: .semibold)
                                .foregroundColor(TerminalTheme.textTertiary)

                            Spacer()

                            if completedCount == chapter.lessons.count && !chapter.lessons.isEmpty {
                                Text("CLEAR")
                                    .shellFont(.caption2, weight: .bold)
                                    .foregroundColor(TerminalTheme.greenPrimary)
                            }
                        }

                        ShellProgressBar(value: progress, height: 6)
                    }
                }
            }
        }
        .buttonStyle(ShellCardButtonStyle())
    }
}

// MARK: - Lesson Row

struct LessonRow: View {
    let number: Int
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel

    private var isCompleted: Bool {
        vm.isLessonCompleted(lesson)
    }

    var body: some View {
        Button {
            vm.navigateToLesson(lesson, in: course)
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Text(String(format: "%02d", number))
                    .shellFont(.caption, weight: .bold)
                    .foregroundColor(TerminalTheme.greenPrimary)
                    .frame(width: 32, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .shellFont(.subheadline, weight: .semibold)
                        .foregroundColor(TerminalTheme.textPrimary)
                        .lineLimit(2)

                    Text("\(lesson.content.typeLabel) / \(lesson.estimatedMinutes) MIN")
                        .shellFont(.caption2)
                        .foregroundColor(TerminalTheme.textTertiary)
                }

                Spacer(minLength: 8)

                Text(isCompleted ? "完了" : "開く")
                    .shellFont(.caption2, weight: .bold)
                    .foregroundColor(isCompleted ? TerminalTheme.greenTertiary : TerminalTheme.textOnAccent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                            .fill(isCompleted ? TerminalTheme.greenPrimary.opacity(0.14) : TerminalTheme.greenPrimary)
                    )
            }
            .padding(11)
            .background(
                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                    .fill(isCompleted ? TerminalTheme.emeraldSoft.opacity(0.55) : TerminalTheme.bgSecondary.opacity(0.92))
            )
            .overlay(
                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                    .stroke(isCompleted ? TerminalTheme.greenPrimary.opacity(0.7) : TerminalTheme.borderColor, lineWidth: 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous))
        }
        .buttonStyle(ShellCardButtonStyle())
    }
}

// MARK: - Lesson View

struct LessonView: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        ThemeFlowView(
            title: lesson.title,
            subtitle: "\(lesson.estimatedMinutes) min / \(course.level.japanese)",
            lessons: [lesson],
            course: course,
            vm: vm
        )
    }
}

enum ThemePhase: Equatable {
    case study
    case practice
    case complete
}

struct ThemeFlowView: View {
    let title: String
    let subtitle: String
    let lessons: [Lesson]
    let course: Course
    @ObservedObject var vm: AppViewModel

    @State private var phase: ThemePhase = .study
    @State private var studyPageIndex = 0
    @State private var practiceIndex = 0
    @State private var didInitialize = false
    @State private var isFlowTransitionLocked = false
    @State private var sessionStudyPages: [StudyPage] = []
    @State private var sessionPracticeItems: [PracticeItem] = []

    private var studyPages: [StudyPage] {
        sessionStudyPages
    }

    private var practiceItems: [PracticeItem] {
        sessionPracticeItems
    }

    private var currentPractice: PracticeItem? {
        guard practiceItems.indices.contains(practiceIndex) else { return nil }
        return practiceItems[practiceIndex]
    }

    private var progressValue: Double {
        let studyWeight = 0.45
        switch phase {
        case .study:
            return Double(studyPageIndex + 1) / Double(max(studyPages.count, 1)) * studyWeight
        case .practice:
            return studyWeight + Double(practiceIndex) / Double(max(practiceItems.count, 1)) * (1 - studyWeight)
        case .complete:
            return 1
        }
    }

    var body: some View {
        ShellScreen {
            VStack(spacing: 0) {
                ShellHeader(
                    title: title,
                    subtitle: subtitle,
                    trailing: "< BACK",
                    action: {
                        vm.goBack()
                    }
                )

                ThemeStageHeader(
                    progress: progressValue
                )

                Group {
                    switch phase {
                    case .study:
                        StudyPageView(
                            page: studyPages[safe: studyPageIndex] ?? StudyPage.fallback(title: title),
                            current: studyPageIndex + 1,
                            total: studyPages.count,
                            canGoBack: studyPageIndex > 0,
                            isLast: studyPageIndex >= studyPages.count - 1,
                            hasPractice: !practiceItems.isEmpty,
                            backAction: previousStudyPage,
                            nextAction: nextStudyPage
                        )
                    case .practice:
                        if let currentPractice {
                            PracticeHostView(
                                lesson: currentPractice.lesson,
                                course: course,
                                vm: vm,
                                isLastPractice: practiceIndex >= practiceItems.count - 1
                            ) {
                                completePractice(currentPractice)
                            }
                            .id(currentPractice.lesson.id)
                            .padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        } else {
                            ThemeCompleteView(title: title) {
                                vm.goBack()
                            }
                        }
                    case .complete:
                        ThemeCompleteView(title: title) {
                            vm.goBack()
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            guard !didInitialize else { return }
            didInitialize = true
            sessionStudyPages = makeStudyPages(from: lessons)
            sessionPracticeItems = makePracticeItems(from: lessons)
            vm.resetLesson()
            if studyPages.isEmpty {
                beginPractice()
            }
        }
    }

    private func previousStudyPage() {
        guard studyPageIndex > 0, !isFlowTransitionLocked else { return }
        lockFlowTransition()
        withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
            studyPageIndex -= 1
        }
    }

    private func nextStudyPage() {
        guard !isFlowTransitionLocked else { return }
        lockFlowTransition()
        if studyPageIndex < studyPages.count - 1 {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                studyPageIndex += 1
            }
        } else {
            beginPractice()
        }
    }

    private func beginPractice() {
        markConceptLessonsWithoutPracticeComplete()
        withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
            if practiceItems.isEmpty {
                phase = .complete
            } else {
                practiceIndex = 0
                phase = .practice
                vm.resetLesson()
            }
        }
    }

    private func completePractice(_ item: PracticeItem) {
        guard !isFlowTransitionLocked else { return }
        lockFlowTransition(duration: 0.42)

        if let completionLesson = item.completionLesson {
            vm.completeLesson(completionLesson)
        }

        withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
            if practiceIndex < practiceItems.count - 1 {
                practiceIndex += 1
                vm.resetLesson()
            } else {
                phase = .complete
            }
        }
    }

    private func markConceptLessonsWithoutPracticeComplete() {
        let practiceCompletionIDs = Set(practiceItems.compactMap { $0.completionLesson?.id })
        for lesson in lessons where lesson.content.isConceptOnly && !practiceCompletionIDs.contains(lesson.id) {
            vm.completeLesson(lesson)
        }
        vm.resetLesson()
    }

    private func lockFlowTransition(duration: Double = 0.28) {
        isFlowTransitionLocked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isFlowTransitionLocked = false
        }
    }
}

struct ThemeStageHeader: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 0) {
            ShellProgressBar(value: progress, height: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(TerminalTheme.bgPrimary.opacity(0.94))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(TerminalTheme.borderColor)
                .frame(height: 1)
        }
    }
}

struct FlowStepPill: View {
    let icon: String
    let title: String
    let isActive: Bool
    let isDone: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(title)
                .shellFont(.caption2, weight: .bold)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundColor(isActive || isDone ? TerminalTheme.textOnAccent : TerminalTheme.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                .fill(background)
        )
    }

    private var background: some ShapeStyle {
        if isActive || isDone {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [TerminalTheme.bluePrimary, TerminalTheme.emeraldPrimary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        return AnyShapeStyle(TerminalTheme.bgTertiary)
    }
}

struct StudyPage: Identifiable {
    let id = UUID()
    let kicker: String
    let title: String
    let body: String
    let code: String?
    let note: String?
    let nearby: [String]

    static func fallback(title: String) -> StudyPage {
        StudyPage(
            kicker: "OVERVIEW",
            title: title,
            body: "このテーマの基礎を確認します。",
            code: nil,
            note: nil,
            nearby: []
        )
    }
}

struct PracticeItem: Identifiable {
    let id = UUID()
    let lesson: Lesson
    let completionLesson: Lesson?
}

struct StudyPageView: View {
    let page: StudyPage
    let current: Int
    let total: Int
    let canGoBack: Bool
    let isLast: Bool
    let hasPractice: Bool
    let backAction: () -> Void
    let nextAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ShellPanel(borderOpacity: 0.22) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(page.kicker.uppercased())
                                .shellFont(.caption2, weight: .bold)
                                .foregroundColor(TerminalTheme.greenPrimary)

                            Text(page.title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(TerminalTheme.textPrimary)
                                .lineLimit(3)
                                .minimumScaleFactor(0.82)

                            Text(page.body)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(TerminalTheme.textSecondary)
                                .lineSpacing(8)

                            if let code = page.code, !code.isEmpty {
                                CodeBlock(code: code)
                            }

                            if let note = page.note, !note.isEmpty {
                                Text(note)
                                    .shellFont(.caption2)
                                    .foregroundColor(TerminalTheme.greenTertiary)
                                    .lineSpacing(3)
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                            .fill(TerminalTheme.emeraldSoft.opacity(0.7))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                            .stroke(TerminalTheme.borderColor, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 12)
            }

            HStack(spacing: 10) {
                Button("BACK", action: backAction)
                    .buttonStyle(ShellButtonStyle(kind: .outline))
                    .disabled(!canGoBack)
                    .opacity(canGoBack ? 1 : 0.36)

                Button(isLast ? (hasPractice ? "PRACTICE" : "CLEAR") : "NEXT", action: nextAction)
                    .buttonStyle(ShellButtonStyle(kind: .filled))
            }
            .padding(16)
            .background(TerminalTheme.bgPrimary.opacity(0.94))
        }
    }
}

struct PracticeHostView: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let isLastPractice: Bool
    let onComplete: () -> Void

    private var finalLabel: String {
        isLastPractice ? "CLEAR" : "NEXT"
    }

    private var usesPinnedHeader: Bool {
        if case .scenario = lesson.content {
            return true
        }
        return false
    }

    var body: some View {
        if usesPinnedHeader {
            content
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.bottom, 12)
        } else {
            ScrollView {
                content
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.bottom, 12)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch lesson.content {
        case .concept(let concept):
            ConceptLessonView(concept: concept)
        case .quest(let quest):
            QuestLessonView(
                quest: quest,
                course: course,
                vm: vm,
                lesson: lesson,
                finalCompleteLabel: finalLabel,
                onComplete: onComplete
            )
        case .scenario(let scenario):
            ScenarioLessonView(
                scenario: scenario,
                course: course,
                vm: vm,
                lesson: lesson,
                finalCompleteLabel: finalLabel,
                onComplete: onComplete
            )
        case .quiz(let quiz):
            QuizLessonView(
                quiz: quiz,
                course: course,
                vm: vm,
                lesson: lesson,
                finalCompleteLabel: finalLabel,
                onComplete: onComplete
            )
        }
    }
}

struct ThemeCompleteView: View {
    let title: String
    let doneAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 0)

            ShellPanel(borderOpacity: 0.34, cornerRadius: TerminalTheme.buttonRadius) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("THEME CLEAR")
                        .shellFont(.caption, weight: .bold)
                        .foregroundColor(TerminalTheme.greenPrimary)

                    Text(title)
                        .shellFont(.title2, weight: .bold)
                        .foregroundColor(TerminalTheme.textPrimary)
                        .lineLimit(3)

                    Text("知識カードと実践問題を完了しました。")
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.textSecondary)
                }
            }

            AdSlotView(placement: .themeComplete)

            Button("一覧へ戻る", action: doneAction)
                .buttonStyle(ShellButtonStyle(kind: .filled))

            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

extension LessonContent {
    var isConceptOnly: Bool {
        if case .concept = self {
            return true
        }
        return false
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private func makeStudyPages(from lessons: [Lesson]) -> [StudyPage] {
    let pages = lessons.flatMap { makeStudyPages(for: $0) }
    return pages.isEmpty ? [StudyPage.fallback(title: "Linux")] : pages
}

private func makePracticeItems(from lessons: [Lesson]) -> [PracticeItem] {
    lessons.flatMap { lesson -> [PracticeItem] in
        switch lesson.content {
        case .concept(let concept):
            return generatedConceptPracticeItems(from: lesson, concept: concept)
        case .quest, .scenario, .quiz:
            return [PracticeItem(lesson: lesson, completionLesson: lesson)]
        }
    }
}

private func generatedConceptPracticeItems(from lesson: Lesson, concept: ConceptLesson) -> [PracticeItem] {
    let questions = concept.sections.prefix(2).map { section in
        QuizQuestion(
            question: "\(section.heading) で押さえるべきことは？",
            choices: conceptChoices(for: section),
            correctIndex: 0,
            explanation: [section.body, section.tip].compactMap { $0 }.joined(separator: "\n\n")
        )
    }

    guard !questions.isEmpty else { return [] }

    let generatedLesson = Lesson(
        title: "\(lesson.title) 確認",
        emoji: "",
        estimatedMinutes: 3,
        content: .quiz(QuizLesson(questions: questions))
    )

    return [PracticeItem(lesson: generatedLesson, completionLesson: lesson)]
}

private func conceptChoices(for section: ConceptSection) -> [String] {
    let correct = conceptCorrectChoice(for: section)
    let distractors = [
        "ファイルを削除する専用操作",
        "ネットワーク通信だけを扱う機能",
        "権限をすべて無効化する設定"
    ]

    return [correct] + distractors.filter { $0 != correct }.prefix(3)
}

private func conceptCorrectChoice(for section: ConceptSection) -> String {
    let heading = section.heading.lowercased()

    if heading.contains("linux") {
        return "OSの中核としてサーバーや開発環境で広く使われる"
    }
    if heading.contains("ターミナル") {
        return "コマンドでLinuxへ指示を出す入口になる"
    }
    if heading.contains("プロンプト") {
        return "ユーザー名、ホスト名、現在地、権限の目印を読む"
    }
    if heading.contains("パス") {
        return "現在地と対象ファイルの位置関係を正しく指定する"
    }
    if heading.contains("権限") {
        return "誰が読み書き実行できるかを制御する"
    }
    if heading.contains("検索") || heading.contains("ログ") {
        return "大量のテキストから必要な行や件数を取り出す"
    }

    return "作業前後の確認と組み合わせて安全に使う"
}

private func makeStudyPages(for lesson: Lesson) -> [StudyPage] {
    switch lesson.content {
    case .concept(let concept):
        return concept.sections.map { section in
            StudyPage(
                kicker: concept.headline,
                title: section.heading,
                body: section.body,
                code: section.codeSample.map { "$ \($0)" },
                note: section.tip,
                nearby: nearbyConcepts(for: section.heading)
            )
        }

    case .quest(let quest):
        return [
            StudyPage(
                kicker: "SITUATION",
                title: lesson.title,
                body: "\(quest.scenario)\n\n\(quest.prompt)",
                code: nil,
                note: "ここではコマンド名だけでなく、どの対象に対して実行するのかも判断します。",
                nearby: []
            ),
            commandStudyPage(
                command: quest.answer,
                title: "\(quest.answer) の使いどころ",
                hint: quest.hint,
                scenario: quest.scenario
            )
        ]

    case .scenario(let scenario):
        let intro = StudyPage(
            kicker: "WORKFLOW",
            title: lesson.title,
            body: "\(scenario.setup)\n\n到達点: \(scenario.goal)",
            code: nil,
            note: "実務では単発のコマンドより、確認、変更、再確認の流れが重要です。",
            nearby: ["本番作業では、削除や権限変更の前に現在状態を確認します。", "ログ解析では、cat より less、tail、grep を組み合わせることが多くなります。"]
        )

        let commandPages = scenario.steps.reduce(into: [StudyPage]()) { result, step in
            guard !result.contains(where: { $0.title.hasPrefix("\(step.answer) ") }) else { return }
            result.append(
                commandStudyPage(
                    command: step.answer,
                    title: "\(step.answer) を実務で使う",
                    hint: step.hint,
                    scenario: step.prompt
                )
            )
        }

        return [intro] + commandPages

    case .quiz(let quiz):
        let body = quiz.questions.enumerated().map { index, question in
            "Q\(index + 1). \(question.question)\n\(question.explanation)"
        }.joined(separator: "\n\n")

        return [
            StudyPage(
                kicker: "KNOWLEDGE",
                title: lesson.title,
                body: body,
                code: nil,
                note: "答えを覚えるより、なぜ他の選択肢ではないのかを見分けられると実務で強くなります。",
                nearby: ["オプション名は短いですが、多くは英単語の頭文字です。例: -r は recursive、-n は number、-i は ignore case。"]
            )
        ]
    }
}

private func commandStudyPage(command: String, title: String, hint: String, scenario: String) -> StudyPage {
    let insight = commandInsight(for: command)
    let body = "\(insight.body)\n\n今回の場面:\n\(scenario)\n\n判断の軸:\n\(hint)"

    return StudyPage(
        kicker: "COMMAND",
        title: title,
        body: body,
        code: insight.example,
        note: insight.note,
        nearby: insight.nearby
    )
}

private struct CommandInsight {
    let body: String
    let example: String?
    let note: String?
    let nearby: [String]
}

private func commandInsight(for rawCommand: String) -> CommandInsight {
    let command = rawCommand
        .split(separator: " ")
        .first
        .map(String.init)?
        .lowercased() ?? rawCommand.lowercased()

    switch command {
    case "pwd":
        return CommandInsight(
            body: "pwd は print working directory の略です。いま自分がどのディレクトリにいるかを絶対パスで表示します。Linux では同じ ls や cat でも、現在地によって対象が変わるため、迷ったら最初に pwd で現在地を確認します。",
            example: "$ pwd\n/home/user/project",
            note: "相対パスで作業しているときほど pwd が効きます。想定外の場所で rm や mv を実行しないための安全確認にもなります。",
            nearby: ["~ はホームディレクトリです。", ". は現在のディレクトリ、.. は1つ上のディレクトリです。"]
        )
    case "ls":
        return CommandInsight(
            body: "ls は list の略で、ディレクトリ内のファイルやフォルダを表示します。実務では ls だけでなく、ls -la で隠しファイルや権限まで確認することが多いです。",
            example: "$ ls -la\n-rw-r--r--  app.log\n-rwxr-xr-x  deploy.sh",
            note: "-l は詳細表示、-a は dotfile を含める指定です。.env や .gitignore のような重要ファイルは -a なしでは見えません。",
            nearby: ["ファイル権限は先頭の rwx で読みます。", "更新日時を見ると、直近で変わったファイルを追いやすくなります。"]
        )
    case "cd":
        return CommandInsight(
            body: "cd は change directory の略です。作業場所を移動します。コマンドは現在地を基準に動くため、cd はすべてのファイル操作の土台です。",
            example: "$ cd /var/log\n$ cd ..\n$ cd ~",
            note: "cd だけを実行するとホームディレクトリに戻ります。パスが長いときは絶対パス、近い場所なら相対パスを使います。",
            nearby: ["絶対パスは / から始まります。", "相対パスは現在地から見た場所です。"]
        )
    case "mkdir":
        return CommandInsight(
            body: "mkdir は make directory の略で、新しいディレクトリを作ります。プロジェクトの整理、ログ保存先、バックアップ先を作るときに使います。",
            example: "$ mkdir reports\n$ mkdir -p logs/2026/04",
            note: "-p を付けると途中のディレクトリもまとめて作れます。すでに存在していてもエラーにしないため、スクリプトでもよく使います。",
            nearby: ["作成後は ls で存在確認します。", "権限がない場所では sudo や権限設計が必要です。"]
        )
    case "touch":
        return CommandInsight(
            body: "touch は空ファイルを作る、またはファイルの更新日時を変えるコマンドです。設定ファイルの雛形やログファイルを先に用意するときに使います。",
            example: "$ touch app.log\n$ touch README.md",
            note: "既存ファイルに touch しても中身は消えません。更新日時だけが変わります。",
            nearby: ["中身を書くなら echo やエディタを使います。", "存在確認は ls、内容確認は cat や less です。"]
        )
    case "cat":
        return CommandInsight(
            body: "cat はファイル内容を標準出力に流します。短い設定ファイルやログの一部を見るには便利ですが、長いログでは less や tail の方が安全です。",
            example: "$ cat config.txt\n$ cat app.log | grep ERROR",
            note: "cat はパイプと相性が良く、次の grep や wc に渡す入口としてよく使われます。",
            nearby: ["長いファイルは less。", "末尾だけなら tail。", "検索するなら grep。"]
        )
    case "cp":
        return CommandInsight(
            body: "cp は copy の略で、ファイルやディレクトリを複製します。変更前のバックアップ、本番反映前の退避、テンプレートからの作成で使います。",
            example: "$ cp config.txt config.backup.txt\n$ cp -r src src_backup",
            note: "ディレクトリをコピーするなら -r が必要です。上書きが発生する場合があるため、コピー先の確認が大切です。",
            nearby: ["移動やリネームは mv。", "削除は rm。", "差分確認には diff が使えます。"]
        )
    case "mv":
        return CommandInsight(
            body: "mv は move の略です。ファイルを移動するだけでなく、名前変更にも使います。Linux ではリネーム専用コマンドではなく mv が基本です。",
            example: "$ mv draft.txt final.txt\n$ mv app.log archive/",
            note: "コピーではなく移動なので、元の場所からは消えます。大事なファイルでは ls で移動先を確認します。",
            nearby: ["別名で残したいなら cp。", "大量移動ではワイルドカードの展開に注意します。"]
        )
    case "rm":
        return CommandInsight(
            body: "rm は remove の略で、ファイルを削除します。Linux の rm はゴミ箱に入れず、基本的には即削除です。",
            example: "$ rm old.log\n$ rm -r old_directory",
            note: "rm -rf は強力で危険です。実務では対象パスを ls で確認してから使います。",
            nearby: ["空ディレクトリだけなら rmdir。", "削除前の退避には cp や mv を使います。"]
        )
    case "grep":
        return CommandInsight(
            body: "grep はテキストから条件に合う行を探します。ログ解析、設定確認、ソースコード検索で頻出です。",
            example: "$ grep ERROR app.log\n$ grep -rin \"timeout\" ./logs",
            note: "-r は再帰検索、-i は大文字小文字を無視、-n は行番号表示です。組み合わせると調査速度が上がります。",
            nearby: ["マッチしない行は grep -v。", "件数だけなら grep -c または wc -l。"]
        )
    case "sed":
        return CommandInsight(
            body: "sed は stream editor です。テキストを行単位で加工します。置換、削除、抽出などをパイプライン内で処理できます。",
            example: "$ sed 's/old/new/g' file.txt\n$ cat app.log | sed 's/ERROR/[ERROR]/g'",
            note: "s/old/new/g の g は1行内の全マッチを置換する指定です。g がないと最初の1回だけです。",
            nearby: ["列単位の処理は awk。", "単純検索は grep。", "ファイルへ保存するならリダイレクトを使います。"]
        )
    case "wc":
        return CommandInsight(
            body: "wc は word count の略です。行数、単語数、バイト数を数えます。ログ件数や検索結果の数を知るときに使います。",
            example: "$ wc -l app.log\n$ grep ERROR app.log | wc -l",
            note: "-l は行数です。grep と組み合わせると、条件に合う件数を素早く数えられます。",
            nearby: ["sort と uniq -c を組み合わせると種類ごとの件数を集計できます。"]
        )
    case "chmod":
        return CommandInsight(
            body: "chmod は change mode の略で、ファイル権限を変更します。スクリプトに実行権限を付けたり、公開してよい範囲を調整したりします。",
            example: "$ chmod +x deploy.sh\n$ chmod 644 config.yml",
            note: "r は読み取り、w は書き込み、x は実行です。数字指定では 4,2,1 を足して表します。",
            nearby: ["所有者変更は chown。", "権限確認は ls -l。", "危険な 777 は原則避けます。"]
        )
    case "chown":
        return CommandInsight(
            body: "chown は change owner の略で、ファイルの所有者やグループを変えます。Web サーバー、デプロイユーザー、root 管理の境界で重要です。",
            example: "$ sudo chown app:app deploy.sh\n$ sudo chown -R www-data:www-data public/",
            note: "-R は配下へ再帰適用です。広い範囲に使う前に対象ディレクトリを必ず確認します。",
            nearby: ["権限そのものは chmod。", "現在の所有者は ls -l で確認します。"]
        )
    case "ps":
        return CommandInsight(
            body: "ps は process status です。実行中のプロセスを一覧します。CPUやメモリが重い原因、止めたい処理の PID を探す入口です。",
            example: "$ ps aux | grep backup.sh",
            note: "PID はプロセスIDです。kill で対象を指定するときに使います。",
            nearby: ["リアルタイム監視は top。", "プロセス終了は kill。"]
        )
    case "top":
        return CommandInsight(
            body: "top はプロセスをリアルタイムに監視します。CPU、メモリ、負荷平均を見て、どの処理が重いかを判断します。",
            example: "$ top",
            note: "top は起動し続ける対話型コマンドです。終了は q が基本です。",
            nearby: ["より見やすい htop が使える環境もあります。", "一度きりの一覧なら ps。"]
        )
    case "kill":
        return CommandInsight(
            body: "kill はプロセスにシグナルを送ります。通常終了を促す、強制終了するなど、PID を指定して制御します。",
            example: "$ kill 1234\n$ kill -9 1234",
            note: "まず通常の kill を使い、最後の手段として kill -9 を使います。強制終了は後片付けを行えない場合があります。",
            nearby: ["対象 PID は ps や top で確認します。", "サービス管理には systemctl を使うことも多いです。"]
        )
    case "ssh":
        return CommandInsight(
            body: "ssh は安全にリモートサーバーへ接続するコマンドです。本番サーバー、VPS、クラウドインスタンスの操作で必須です。",
            example: "$ ssh user@example.com\n$ ssh -i key.pem ubuntu@server",
            note: "鍵認証では秘密鍵を安全に保管します。権限が緩すぎる鍵は SSH が拒否することがあります。",
            nearby: ["ファイル転送には scp や rsync。", "接続先の設定は ~/.ssh/config にまとめられます。"]
        )
    case "curl":
        return CommandInsight(
            body: "curl は URL にリクエストを送り、レスポンスを確認します。API疎通、ヘルスチェック、認証確認で使います。",
            example: "$ curl -I https://example.com\n$ curl -s https://api.example.com/health",
            note: "-I はヘッダーだけ、-s は進捗表示を消します。HTTP ステータスを見るだけでも障害調査に役立ちます。",
            nearby: ["JSON 整形には jq。", "ファイル取得には wget も使われます。"]
        )
    case "jq":
        return CommandInsight(
            body: "jq は JSON を整形、抽出、加工するコマンドです。APIレスポンスや設定JSONを読むときに非常に便利です。",
            example: "$ curl -s https://api.example.com/users | jq '.data[0].name'",
            note: "jq '.' だけでも整形表示になります。深いJSONを目で追うより、必要なキーだけ抽出するとミスが減ります。",
            nearby: ["API取得は curl。", "テキスト検索は grep。", "JSONの配列処理にも強いです。"]
        )
    case "apt":
        return CommandInsight(
            body: "apt は Debian/Ubuntu 系のパッケージ管理コマンドです。ソフトウェアのインストール、更新、削除に使います。",
            example: "$ sudo apt update\n$ sudo apt install nginx",
            note: "apt update はパッケージ一覧の更新、apt upgrade はインストール済みパッケージの更新です。意味が違います。",
            nearby: ["Red Hat 系では dnf や yum。", "インストール済み確認には apt list --installed。"]
        )
    default:
        return CommandInsight(
            body: "\(rawCommand) は、このテーマの状況を処理するためのコマンドです。Linux では、コマンド名、対象、オプション、出力の流れをセットで理解すると実務で使える知識になります。",
            example: "$ \(rawCommand)",
            note: "分からないコマンドは man \(command) や \(command) --help で確認できます。",
            nearby: ["コマンドは単体より、パイプやリダイレクトと組み合わせる場面が多いです。"]
        )
    }
}

private func nearbyConcepts(for heading: String) -> [String] {
    let lower = heading.lowercased()
    if lower.contains("パス") || lower.contains("directory") || lower.contains("ディレクトリ") {
        return ["絶対パスは / から始まります。", "相対パスは現在地から見た指定です。", "作業前に pwd、作業後に ls を使うと迷いにくくなります。"]
    }
    if lower.contains("権限") || lower.contains("permission") {
        return ["権限は user、group、others の3層で考えます。", "読み取り r、書き込み w、実行 x を組み合わせます。"]
    }
    if lower.contains("ログ") || lower.contains("検索") {
        return ["ログは grep、tail、less、wc を組み合わせて読むことが多いです。", "件数確認と内容確認は分けると調査が速くなります。"]
    }
    return ["実務では、確認、実行、再確認の順で進めると事故が減ります。"]
}

// MARK: - Concept Lesson View

struct ConceptLessonView: View {
    let concept: ConceptLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ShellSectionTitle(title: "CONCEPT", subtitle: concept.headline)

            ForEach(concept.sections) { section in
                ShellPanel(borderOpacity: 0.18) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(section.heading.uppercased())
                            .shellFont(.subheadline, weight: .bold)
                            .foregroundColor(TerminalTheme.textPrimary)

                        Text(section.body)
                            .shellFont(.caption)
                            .foregroundColor(TerminalTheme.textSecondary)
                            .lineSpacing(3)

                        if let code = section.codeSample {
                            CodeBlock(code: "$ \(code)")
                        }

                        if let tip = section.tip {
                            Text("NOTE: \(tip)")
                                .shellFont(.caption2)
                                .foregroundColor(TerminalTheme.greenTertiary)
                                .lineSpacing(2)
                                .padding(9)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                        .fill(TerminalTheme.greenPrimary.opacity(0.08))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                        .stroke(TerminalTheme.borderColor, lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
    }
}

struct CodeBlock: View {
    let code: String

    var body: some View {
        Text(code)
            .font(.system(.caption, design: .monospaced).weight(.regular))
            .foregroundColor(TerminalTheme.greenPrimary)
            .textSelection(.enabled)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TerminalTheme.terminalBackground)
            .overlay(
                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                    .stroke(TerminalTheme.bluePrimary.opacity(0.22), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous))
    }
}

// MARK: - Quest Lesson View

struct QuestLessonView: View {
    let quest: QuestLesson
    let course: Course
    @ObservedObject var vm: AppViewModel
    let lesson: Lesson
    var finalCompleteLabel: String = "COMPLETE LESSON"
    var onComplete: (() -> Void)? = nil
    @State private var selectedTarget: String?
    @State private var showCompletion = false
    @State private var isCompleting = false

    private var requiredTarget: String? {
        expectedTargetToken(from: targetSourceText, answer: quest.answer, allowContextFallback: false)
    }

    private var targetSourceText: String {
        "\(quest.hint) \(quest.prompt) \(quest.scenario)"
    }

    private var targetChoices: [String] {
        guard let requiredTarget else { return [] }
        return targetOptions(from: targetSourceText, expected: requiredTarget)
    }

    private var terminalInput: String {
        terminalCommandLine(command: vm.userInput, target: selectedTarget)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProblemBriefPanel(
                title: "問題",
                subtitle: nil,
                text: quest.prompt,
                detail: quest.scenario
            )

            TerminalPanel(
                input: terminalInput,
                output: vm.terminalOutput,
                state: vm.currentLessonState,
                successMessage: quest.successMessage,
                minHeight: 112
            )

            Spacer(minLength: 0)

            WordBankPanel(
                targets: targetChoices,
                selectedTarget: $selectedTarget,
                options: quest.options,
                selectedCommand: vm.userInput,
                areTargetsDisabled: vm.currentLessonState != .waiting || isCompleting,
                areCommandsDisabled: vm.currentLessonState != .waiting || vm.isTyping || isCompleting
            ) { option in
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                vm.selectCommand(option)
            }

            ActionBar(
                canRun: (targetChoices.isEmpty || selectedTarget != nil) && !vm.userInput.isEmpty && !vm.isTyping && vm.currentLessonState == .waiting && !isCompleting,
                state: vm.currentLessonState,
                completeLabel: finalCompleteLabel,
                runAction: {
                    let impact = UIImpactFeedbackGenerator(style: .heavy)
                    impact.impactOccurred()
                    if requiredTarget == nil || selectedTarget == requiredTarget {
                        vm.executeQuest(quest)
                    } else {
                        vm.failSelection("対象が違います: \(selectedTarget ?? "未選択")")
                    }
                },
                retryAction: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    selectedTarget = nil
                    vm.retry()
                },
                completeAction: {
                    guard !isCompleting else { return }
                    isCompleting = true
                    let impact = UINotificationFeedbackGenerator()
                    impact.notificationOccurred(.success)
                    showCompletion = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        if let onComplete {
                            onComplete()
                        } else {
                            vm.completeLesson(lesson)
                            vm.goBack()
                        }
                    }
                }
            )
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .overlay(
            showCompletion ? SuccessOverlayView {
                showCompletion = false
            } : nil
        )
    }
}

struct ProblemBriefPanel: View {
    let title: String
    let subtitle: String?
    let text: String
    let detail: String

    var body: some View {
        ShellPanel(borderOpacity: 0.18) {
            VStack(alignment: .leading, spacing: 8) {
                ShellSectionTitle(title: title, subtitle: subtitle)

                Text(text)
                    .shellFont(.subheadline, weight: .semibold)
                    .foregroundColor(TerminalTheme.textPrimary)
                    .lineLimit(3)
                    .lineSpacing(2)

                Text(detail)
                    .shellFont(.caption2)
                    .foregroundColor(TerminalTheme.textSecondary)
                    .lineLimit(2)
            }
        }
    }
}

struct TargetSelectionPanel: View {
    let targets: [String]
    @Binding var selectedTarget: String?

    var body: some View {
        ShellPanel(borderOpacity: 0.2) {
            VStack(alignment: .leading, spacing: 10) {
                ShellSectionTitle(title: "TARGET")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(targets, id: \.self) { target in
                        Button {
                            withAnimation(.spring(response: 0.24, dampingFraction: 0.78)) {
                                selectedTarget = target
                            }
                        } label: {
                            Text(target)
                        }
                        .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedTarget == target))
                    }
                }

            }
        }
    }
}

struct WordBankPanel: View {
    let targets: [String]
    @Binding var selectedTarget: String?
    let options: [CommandOption]
    let selectedCommand: String
    let areTargetsDisabled: Bool
    let areCommandsDisabled: Bool
    let onSelect: (CommandOption) -> Void
    @State private var shuffledTargets: [String] = []
    @State private var shuffledOptions: [CommandOption] = []

    private var displayedTargets: [String] {
        shuffledTargets.isEmpty ? targets : shuffledTargets
    }

    private var displayedOptions: [CommandOption] {
        shuffledOptions.isEmpty ? options : shuffledOptions
    }

    var body: some View {
        ShellPanel(borderOpacity: 0.26) {
            VStack(alignment: .leading, spacing: 10) {
                ShellSectionTitle(title: "語群")

                if !displayedTargets.isEmpty {
                    Text("対象")
                        .shellFont(.caption2, weight: .bold)
                        .foregroundColor(TerminalTheme.textTertiary)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(displayedTargets, id: \.self) { target in
                            Button {
                                withAnimation(.easeOut(duration: 0.12)) {
                                    selectedTarget = target
                                }
                            } label: {
                                Text(target)
                            }
                            .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedTarget == target))
                            .disabled(areTargetsDisabled)
                            .opacity(areTargetsDisabled ? 0.48 : 1)
                        }
                    }
                }

                Text("コマンド")
                    .shellFont(.caption2, weight: .bold)
                    .foregroundColor(TerminalTheme.textTertiary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(displayedOptions) { option in
                        CommandButton(
                            option: option,
                            isSelected: selectedCommand == option.command,
                            isDisabled: areCommandsDisabled
                        ) {
                            onSelect(option)
                        }
                    }
                }
            }
        }
        .onAppear {
            reshuffle()
        }
        .onChange(of: targets) {
            shuffledTargets = targets.shuffled()
        }
        .onChange(of: options.map(\.id)) {
            shuffledOptions = options.shuffled()
        }
    }

    private func reshuffle() {
        shuffledTargets = targets.shuffled()
        shuffledOptions = options.shuffled()
    }
}

struct CommandSelectionPanel: View {
    let options: [CommandOption]
    let selectedCommand: String
    let isDisabled: Bool
    let onSelect: (CommandOption) -> Void

    var body: some View {
        ShellPanel(borderOpacity: 0.2) {
            VStack(alignment: .leading, spacing: 10) {
                ShellSectionTitle(title: "COMMAND")

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(options) { option in
                        CommandButton(
                            option: option,
                            isSelected: selectedCommand == option.command,
                            isDisabled: isDisabled
                        ) {
                            onSelect(option)
                        }
                    }
                }
            }
        }
    }
}

struct ActionBar: View {
    let canRun: Bool
    let state: LessonState
    let completeLabel: String
    let runAction: () -> Void
    let retryAction: () -> Void
    let completeAction: () -> Void
    @State private var isActionLocked = false

    var body: some View {
        HStack(spacing: 10) {
            if state == .wrong {
                Button("RESET") {
                    lockAndRun(retryAction)
                }
                    .buttonStyle(ShellButtonStyle(kind: .outline))
                    .disabled(isActionLocked)
            }

            if state != .correct && state != .completed {
                Button("RUN") {
                    lockAndRun(runAction)
                }
                .buttonStyle(ShellButtonStyle(kind: canRun ? .filled : .dim))
                .disabled(!canRun || isActionLocked)
                .opacity(canRun && !isActionLocked ? 1 : 0.46)
            }

            if state == .correct {
                Button(completeLabel) {
                    lockAndRun(completeAction, duration: 0.8)
                }
                    .buttonStyle(ShellButtonStyle(kind: .filled))
                    .disabled(isActionLocked)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private func lockAndRun(_ action: @escaping () -> Void, duration: Double = 0.28) {
        guard !isActionLocked else { return }
        isActionLocked = true
        action()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isActionLocked = false
        }
    }
}

// MARK: - Terminal Panel

struct TerminalPanel: View {
    let input: String
    let output: String
    let state: LessonState
    let successMessage: String
    var minHeight: CGFloat = 132

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("SIMULATED SHELL")
                    .shellFont(.caption2, weight: .bold)
                    .foregroundColor(TerminalTheme.greenPrimary)
                Spacer()
                Text(statusText)
                    .shellFont(.caption2, weight: .bold)
                    .foregroundColor(TerminalTheme.terminalMuted)
            }
            .padding(9)
            .background(TerminalTheme.terminalBackground)
            .overlay(
                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                    .stroke(TerminalTheme.bluePrimary.opacity(0.2), lineWidth: 1)
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("user@linatex:~$")
                            .foregroundColor(TerminalTheme.greenPrimary)
                            .font(.system(.caption, design: .monospaced).weight(.semibold))
                        Text(input)
                            .foregroundColor(input.isEmpty ? TerminalTheme.terminalMuted : inputColor)
                            .font(.system(.caption, design: .monospaced))
                        if state == .waiting {
                            CursorView()
                        }
                        Spacer(minLength: 0)
                    }

                    if !output.isEmpty {
                        Text(output)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(outputColor)
                            .lineSpacing(2)
                            .textSelection(.enabled)
                    }

                    if state == .correct {
                        Text("OK: \(successMessage)")
                            .shellFont(.caption2, weight: .bold)
                            .foregroundColor(TerminalTheme.greenPrimary)
                            .padding(.top, 4)
                    }

                    if state == .wrong {
                        Text("REVIEW: SELECT A DIFFERENT COMMAND")
                            .shellFont(.caption2, weight: .bold)
                            .foregroundColor(TerminalTheme.terminalMuted)
                            .padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            }
            .frame(height: minHeight)
            .background(TerminalTheme.terminalSurface)
        }
        .background(TerminalTheme.terminalBackground)
        .overlay(
            RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                .stroke(TerminalTheme.bluePrimary.opacity(0.32), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous))
    }

    private var statusText: String {
        switch state {
        case .waiting: return "WAIT"
        case .correct: return "OK"
        case .wrong: return "RETRY"
        case .completed: return "DONE"
        }
    }

    private var inputColor: Color {
        switch state {
        case .correct: return TerminalTheme.greenPrimary
        case .wrong: return TerminalTheme.terminalMuted
        default: return TerminalTheme.terminalText
        }
    }

    private var outputColor: Color {
        state == .wrong ? TerminalTheme.terminalMuted : TerminalTheme.terminalText
    }
}

// MARK: - Cursor

struct CursorView: View {
    var body: some View {
        Rectangle()
            .fill(TerminalTheme.greenPrimary)
            .frame(width: 7, height: 14)
            .opacity(0.55)
    }
}

// MARK: - Command Button

struct CommandButton: View {
    let option: CommandOption
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 4) {
                Text(option.label.uppercased())
                    .shellFont(.caption, weight: .bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("$ \(option.command)")
                    .shellFont(.caption2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.64)
            }
        }
        .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: isSelected))
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.48 : 1)
    }
}

func targetOptions(from text: String, expected: String?) -> [String] {
    var options: [String] = []
    if let expected {
        options.append(expected)
    }
    options.append(contentsOf: targetTokens(from: text).filter { $0 != expected })

    var seen: Set<String> = []
    return options
        .filter { seen.insert($0.uppercased()).inserted }
        .prefix(4)
        .map { $0 }
}

func terminalCommandLine(command: String, target: String?) -> String {
    let trimmedCommand = command.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let target, !target.isEmpty else { return trimmedCommand }

    if trimmedCommand.isEmpty {
        return target
    }

    if trimmedCommand.range(of: target, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
        return trimmedCommand
    }

    return "\(trimmedCommand) \(target)"
}

func expectedTargetToken(from hint: String, answer: String, allowContextFallback: Bool = true) -> String? {
    if let explicitTarget = targetTokens(from: answer).first {
        return explicitTarget
    }

    guard allowContextFallback else { return nil }

    let tokens = targetTokens(from: hint, preservingCommands: true)
    let answerCommand = answer
        .components(separatedBy: .whitespacesAndNewlines)
        .first?
        .uppercased() ?? answer.uppercased()

    guard let answerIndex = tokens.firstIndex(where: { $0.uppercased() == answerCommand }) else {
        return targetTokens(from: hint).first
    }

    for token in tokens.suffix(from: tokens.index(after: answerIndex)) {
        let normalizedToken = token.uppercased()
        if token.hasPrefix("-") || token == "|" || normalizedToken == "SUDO" || normalizedToken == answer.uppercased() {
            continue
        }
        return token
    }

    return nil
}

private func targetTokens(from text: String, preservingCommands: Bool = false) -> [String] {
    let trimCharacters = CharacterSet(charactersIn: "、。,:;!?()[]{}「」『』\"'`")
    let stopWords: Set<String> = [
        "で", "を", "に", "へ", "から", "します", "する", "コマンド", "ファイル",
        "HINT", "THE", "AND", "WITH", "PRINT", "WORKING", "DIRECTORY"
    ]

    let commandWords: Set<String> = [
        "PWD", "LS", "CD", "MKDIR", "TOUCH", "CAT", "CP", "MV", "RM", "GREP",
        "SED", "AWK", "WC", "SORT", "UNIQ", "CHMOD", "CHOWN", "CHGRP", "UMASK",
        "BASH", "SH", "SSH", "CURL", "WGET", "JQ", "PS", "TOP", "KILL", "APT",
        "DPKG", "YUM", "SUDO"
    ]

    var seen: Set<String> = []

    return text
        .components(separatedBy: .whitespacesAndNewlines)
        .map { $0.trimmingCharacters(in: trimCharacters) }
        .filter { !$0.isEmpty }
        .filter { token in
            let normalizedToken = token.uppercased()
            if stopWords.contains(normalizedToken) {
                return false
            }
            if commandWords.contains(normalizedToken) {
                return preservingCommands
            }

            return token.contains(".") ||
                token.contains("/") ||
                token.contains("@") ||
                normalizedToken == "DESKTOP" ||
                normalizedToken == "DOCUMENTS" ||
                normalizedToken == "ARCHIVE" ||
                normalizedToken == "PROJECT"
        }
        .filter { seen.insert($0.uppercased()).inserted }
}

// MARK: - Use implemented views from LessonImplementations.swift

typealias ScenarioLessonView = ScenarioLessonViewImpl
typealias QuizLessonView = QuizLessonViewImpl

#Preview {
    ContentView()
}
