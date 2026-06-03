import SwiftUI
import Combine
import UIKit

// MARK: - Navigation States

enum AppScreen: Hashable {
    case home
    case commandDictionary
    case courseDetail(Course)
    case chapter(Chapter, Course)
    case lesson(Lesson, Course)
}

enum LessonState {
    case waiting
    case correct
    case wrong
    case completed
}

// MARK: - App ViewModel

class AppViewModel: ObservableObject {
    private let store = ProgressStore.shared

    @Published var navigationPath: [AppScreen] = []

    // Dictionary search query (for error context)
    @Published var dictionarySearchQuery: String = ""
    @Published var completedLessons: Set<UUID> = []
    @Published var totalXP: Int = 0
    @Published var streak: Int = 0
    @Published var totalLessonAttempts: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var unlockedAchievements: Set<String> = []

    // Today's learning stats
    @Published var todayLessonsCompleted: Int = 0
    @Published var todayEstimatedMinutes: Int = 0
    @Published var lastResetDate: Date = Date()

    // Lesson state
    @Published var currentLessonState: LessonState = .waiting
    @Published var userInput: String = ""
    @Published var terminalOutput: String = ""
    @Published var isTyping: Bool = false
    @Published var isExecuting: Bool = false
    @Published var isReviewMode: Bool = false
    private var typingSessionID = UUID()
    private var isNavigationLocked = false

    @Published var isDarkMode: Bool = false

    var courses: [Course] { comprehensiveAllCourses }

    var successRate: Double {
        totalLessonAttempts > 0 ? Double(correctAnswers) / Double(totalLessonAttempts) * 100 : 0
    }

    var estimatedLearningTime: Int {
        completedLessons.count * 10
    }

    // MARK: - Init

    init() {
        completedLessons = Set(store.completedLessonIDs.compactMap { UUID(uuidString: $0) })
        totalXP = store.totalXP
        streak = store.streak
        totalLessonAttempts = store.totalLessonAttempts
        correctAnswers = store.correctAnswers
        unlockedAchievements = store.unlockedAchievementIDs
        checkStreakOnLaunch()
    }

    // Reset streak if the user skipped more than one day since last study.
    private func checkStreakOnLaunch() {
        guard let lastDate = store.lastStudyDate else { return }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let last  = calendar.startOfDay(for: lastDate)
        let daysDiff = calendar.dateComponents([.day], from: last, to: today).day ?? 0
        if daysDiff > 1 {
            streak = 0
            store.streak = 0
        }
    }

    // MARK: - Navigation

    func navigateToCourse(_ course: Course) {
        guard lockNavigation() else { return }
        navigationPath.append(.courseDetail(course))
    }

    func navigateToCommandDictionary(searchQuery: String = "") {
        guard lockNavigation() else { return }
        dictionarySearchQuery = searchQuery
        navigationPath.append(.commandDictionary)
    }

    func navigateToLesson(_ lesson: Lesson, in course: Course) {
        guard lockNavigation() else { return }
        navigationPath.append(.lesson(lesson, course))
    }

    func navigateToChapter(_ chapter: Chapter, in course: Course) {
        guard lockNavigation() else { return }
        navigationPath.append(.chapter(chapter, course))
    }

    func goBack() {
        guard lockNavigation() else { return }
        if !navigationPath.isEmpty { navigationPath.removeLast() }
    }

    private func lockNavigation(duration: Double = 0.35) -> Bool {
        guard !isNavigationLocked else { return false }
        isNavigationLocked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { self.isNavigationLocked = false }
        return true
    }

    // MARK: - Lesson Logic

    func selectCommand(_ option: CommandOption) {
        selectCommandText(option.command)
    }

    func selectCommandText(_ command: String) {
        guard currentLessonState == .waiting, !isTyping else { return }
        let sessionID = UUID()
        typingSessionID = sessionID
        isTyping = true
        userInput = ""

        for (i, char) in command.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                guard self.typingSessionID == sessionID else { return }
                self.userInput.append(char)
                if i == command.count - 1 { self.isTyping = false }
            }
        }
    }

    func executeQuest(_ quest: QuestLesson) {
        executeQuest(quest, enteredCommand: userInput)
    }

    func executeQuest(_ quest: QuestLesson, enteredCommand: String) {
        guard !enteredCommand.isEmpty, !isTyping, !isExecuting, currentLessonState == .waiting else { return }

        isExecuting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let trimmed = normalizedCommandLine(enteredCommand)
            if trimmed == normalizedCommandLine(quest.answer) {
                self.currentLessonState = .correct
                self.terminalOutput = quest.simulatedOutput
                self.addXP(50)
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } else {
                self.currentLessonState = .wrong
                let hint = self.generateHint(for: trimmed, expectedAnswer: quest.answer)
                self.terminalOutput = hint
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            self.isExecuting = false
        }
    }

    func executeScenarioStep(_ step: ScenarioStep) {
        executeScenarioStep(step, enteredCommand: userInput)
    }

    func executeScenarioStep(_ step: ScenarioStep, enteredCommand: String) {
        guard !enteredCommand.isEmpty, !isTyping, !isExecuting, currentLessonState == .waiting else { return }

        isExecuting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let trimmed = normalizedCommandLine(enteredCommand)
            if trimmed == normalizedCommandLine(step.answer) {
                self.currentLessonState = .correct
                self.terminalOutput = step.simulatedOutput
                self.addXP(30)
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } else {
                self.currentLessonState = .wrong
                let hint = self.generateHint(for: trimmed, expectedAnswer: step.answer)
                self.terminalOutput = hint
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            self.isExecuting = false
        }
    }

    private func generateHint(for userAnswer: String, expectedAnswer: String) -> String {
        let userParts = userAnswer.split(separator: " ", maxSplits: 1).map(String.init)
        let expectedParts = expectedAnswer.split(separator: " ", maxSplits: 1).map(String.init)

        if userParts.isEmpty {
            return "コマンドを入力してください。例: \(expectedParts.first ?? "ls")"
        }

        if userParts[0] != expectedParts[0] {
            let expectedCommand = expectedParts[0]
            let userCommand = userParts[0]
            let definition = getCommandDefinition(expectedCommand)
            return "❌ コマンドが違います\n期待: \(expectedCommand)\n入力: \(userCommand)\n\n📚 \(expectedCommand)とは：\n\(definition)"
        }

        if userParts.count < expectedParts.count {
            let expectedArgs = expectedParts.count > 1 ? expectedParts[1] : "ファイル名やオプション"
            return "❌ コマンドが不完全です\nこのコマンドには引数が必要です。\n例: \(expectedAnswer)"
        }

        if userParts.count > expectedParts.count {
            return "❌ 引数が多すぎる可能性があります\n期待される形式: \(expectedAnswer)"
        }

        return "❌ コマンドの形式が異なります\n期待: \(expectedAnswer)\n入力: \(userAnswer)"
    }

    private func getCommandDefinition(_ command: String) -> String {
        let definitions: [String: String] = [
            "ls": "ファイルやディレクトリを一覧表示する基本コマンド",
            "cd": "ディレクトリ（フォルダ）を移動するコマンド",
            "pwd": "現在のディレクトリパスを表示するコマンド",
            "cat": "ファイルの内容を表示するコマンド",
            "grep": "テキストから特定の文字列を検索するコマンド",
            "chmod": "ファイルのアクセス権限を変更するコマンド",
            "rm": "ファイルやディレクトリを削除するコマンド",
            "cp": "ファイルやディレクトリをコピーするコマンド",
            "mv": "ファイルやディレクトリを移動・名前変更するコマンド",
            "mkdir": "新しいディレクトリを作成するコマンド",
            "touch": "空のファイルを作成するコマンド",
            "find": "ファイルやディレクトリを検索するコマンド",
            "wc": "ファイルの行数、単語数、文字数を数えるコマンド",
            "sort": "テキストを並べ替えるコマンド",
            "uniq": "重複した行を除去するコマンド",
            "sed": "テキストを置換・削除などで編集するコマンド",
            "awk": "テキストを分析・処理するコマンド",
            "tar": "ファイルをアーカイブに圧縮するコマンド",
            "gzip": "ファイルを圧縮するコマンド",
            "curl": "Webからデータを取得するコマンド",
            "ssh": "リモートサーバーに安全に接続するコマンド",
            "scp": "SSH経由でファイルを転送するコマンド",
        ]
        return definitions[command] ?? "このコマンドについては辞典を確認してください"
    }

    func completeLesson(_ lesson: Lesson) {
        guard !completedLessons.contains(lesson.id) else {
            currentLessonState = .completed
            return
        }

        completedLessons.insert(lesson.id)
        store.completedLessonIDs.insert(lesson.id.uuidString)

        addXP(100)
        updateStreak()
        totalLessonAttempts += 1
        store.totalLessonAttempts = totalLessonAttempts
        correctAnswers += 1
        store.correctAnswers = correctAnswers
        currentLessonState = .completed
        checkAndUnlockAchievements()

        // Update today's learning stats
        resetTodayStatsIfNeeded()
        todayLessonsCompleted += 1
        todayEstimatedMinutes += lesson.estimatedMinutes

        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    private func resetTodayStatsIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastReset = calendar.startOfDay(for: lastResetDate)

        if today > lastReset {
            todayLessonsCompleted = 0
            todayEstimatedMinutes = 0
            lastResetDate = Date()
        }
    }

    // Streak = consecutive calendar days with at least one lesson completed.
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = store.lastStudyDate {
            let last = calendar.startOfDay(for: lastDate)
            let daysDiff = calendar.dateComponents([.day], from: last, to: today).day ?? 0
            if daysDiff == 0 {
                // Already studied today — streak unchanged
            } else if daysDiff == 1 {
                streak += 1
            } else {
                streak = 1
            }
        } else {
            streak = 1
        }

        store.streak = streak
        store.lastStudyDate = Date()
    }

    func nextStep() {
        typingSessionID = UUID()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentLessonState = .waiting
            userInput = ""
            terminalOutput = ""
        }
    }

    func retry() {
        typingSessionID = UUID()
        withAnimation(.easeInOut(duration: 0.3)) {
            currentLessonState = .waiting
            userInput = ""
            terminalOutput = ""
        }
    }

    func failSelection(_ message: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentLessonState = .wrong
            terminalOutput = message
        }
    }

    func resetLesson() {
        typingSessionID = UUID()
        currentLessonState = .waiting
        userInput = ""
        terminalOutput = ""
        isTyping = false
    }

    // MARK: - Progress

    func isLessonCompleted(_ lesson: Lesson) -> Bool {
        completedLessons.contains(lesson.id)
    }

    func progressInCourse(_ course: Course) -> Double {
        let totalLessons = course.totalLessons
        let completedCount = course.chapters.reduce(0) { total, chapter in
            total + chapter.lessons.filter { isLessonCompleted($0) }.count
        }
        return totalLessons > 0 ? Double(completedCount) / Double(totalLessons) : 0
    }

    func totalProgress() -> Double {
        let totalLessons = courses.reduce(0) { $0 + $1.totalLessons }
        return totalLessons > 0 ? Double(completedLessons.count) / Double(totalLessons) : 0
    }

    func addXP(_ amount: Int) {
        withAnimation(.easeInOut(duration: 0.5)) {
            totalXP += amount
            store.totalXP = totalXP
        }
    }

    // MARK: - Next Uncompleted Lesson (for Continue card on Home)

    func nextUncompletedLesson() -> (lesson: Lesson, course: Course)? {
        for course in courses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    if !isLessonCompleted(lesson) { return (lesson, course) }
                }
            }
        }
        return nil
    }

    func randomUncompletedLesson() -> (lesson: Lesson, course: Course)? {
        var allUncompletedLessons: [(lesson: Lesson, course: Course)] = []
        for course in courses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    if !isLessonCompleted(lesson) {
                        allUncompletedLessons.append((lesson, course))
                    }
                }
            }
        }
        return allUncompletedLessons.randomElement()
    }

    // MARK: - Achievements

    func checkAndUnlockAchievements() {
        for achievement in allAchievements {
            guard !unlockedAchievements.contains(achievement.id) else { continue }
            if checkAchievementRequirement(achievement.requirement) {
                unlockedAchievements.insert(achievement.id)
                store.unlockedAchievementIDs.insert(achievement.id)
            }
        }
    }

    private func checkAchievementRequirement(_ requirement: AchievementRequirement) -> Bool {
        switch requirement {
        case .lessonsCompleted(let count):  return completedLessons.count >= count
        case .xpReached(let amount):        return totalXP >= amount
        case .streakDays(let days):         return streak >= days
        case .successRate(let target):      return successRate >= target
        case .courseCompleted:              return false // TODO: implement per-course check
        case .firstLesson:                  return !completedLessons.isEmpty
        case .allConceptLessons:            return checkAllLessonsOfType(.concept)
        case .allQuestLessons:              return checkAllLessonsOfType(.quest)
        case .allScenarioLessons:           return checkAllLessonsOfType(.scenario)
        }
    }

    private func checkAllLessonsOfType(_ type: LessonType) -> Bool {
        let allLessonsOfType = courses.flatMap { course in
            course.chapters.flatMap { chapter in
                chapter.lessons.filter { lesson in
                    switch (lesson.content, type) {
                    case (.concept, .concept): return true
                    case (.quest, .quest):     return true
                    case (.scenario, .scenario): return true
                    case (.quiz, .quiz):       return true
                    default:                   return false
                    }
                }
            }
        }
        guard !allLessonsOfType.isEmpty else { return false }
        return allLessonsOfType.allSatisfy { completedLessons.contains($0.id) }
    }

    func getUnlockedBadges() -> [Achievement] {
        allAchievements.filter { unlockedAchievements.contains($0.id) }
    }

    // MARK: - Learning Path Management

    func updateLearningProfile() {
        learningProfile = LearningPathAnalyzer.analyzeUserProfile(self)
    }

    func updatePersonalizedRecommendation() {
        personalizedRecommendation = RecommendationEngine.getRecommendation(self)
    }

    func getNextRecommendedLessons(count: Int = 3) -> [Lesson] {
        AdaptivePathGenerator.generateNextLessons(self, count: count)
    }

    func getLearningStyleDescription() -> String {
        guard let profile = learningProfile else { return "分析中..." }
        switch profile.learningStyle {
        case .conceptPreferred:  return "理論的学習型 - コンセプトから理解するのが得意"
        case .questPreferred:    return "シンプルタスク型 - 単純なコマンド実行で理解"
        case .scenarioPreferred: return "実践シナリオ型 - 複雑なタスク解決が得意"
        case .quizPreferred:     return "知識確認型 - クイズで知識を定着させるタイプ"
        case .balanced:          return "バランス型 - すべての学習形式をバランスよく活用"
        }
    }

    func getWeakAreasString() -> String {
        guard let profile = learningProfile, !profile.weakTopics.isEmpty else {
            return "弱点なし！すべての領域で好調です"
        }
        return profile.weakTopics.joined(separator: ", ")
    }

    func getRecommendedNextSteps() -> String {
        guard let recommendation = personalizedRecommendation else {
            return "レッスンを進めてデータを集めましょう"
        }
        return recommendation.reason
    }
}
