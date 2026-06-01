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
    @Published var completedLessons: Set<UUID> = []
    @Published var totalXP: Int = 0
    @Published var streak: Int = 0
    @Published var totalLessonAttempts: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var unlockedAchievements: Set<String> = []

    // Lesson state
    @Published var currentLessonState: LessonState = .waiting
    @Published var userInput: String = ""
    @Published var terminalOutput: String = ""
    @Published var isTyping: Bool = false
    @Published var isExecuting: Bool = false
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

    func navigateToCommandDictionary() {
        guard lockNavigation() else { return }
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
                self.terminalOutput = "答えが違います。\(hint)"
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
                self.terminalOutput = "答えが違います。\(hint)"
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            self.isExecuting = false
        }
    }

    private func generateHint(for userAnswer: String, expectedAnswer: String) -> String {
        let userParts = userAnswer.split(separator: " ", maxSplits: 1).map(String.init)
        let expectedParts = expectedAnswer.split(separator: " ", maxSplits: 1).map(String.init)

        if userParts.isEmpty {
            return "コマンドを入力してください。"
        }

        if userParts[0] != expectedParts[0] {
            let expectedCommand = expectedParts[0]
            return "コマンド '\(expectedCommand)' を使ってみてください。"
        }

        if userParts.count < expectedParts.count {
            return "引数や対象ファイルが不足しているかもしれません。"
        }

        return "コマンドのオプションや引数を確認してください。"
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

        UINotificationFeedbackGenerator().notificationOccurred(.success)
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
