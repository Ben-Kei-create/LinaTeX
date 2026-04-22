import SwiftUI
import Combine

// MARK: - Navigation States

enum AppScreen {
    case home
    case courseDetail(Course)
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
    @Published var showHint: Bool = false
    @Published var isTyping: Bool = false

    var courses: [Course] { comprehensiveAllCourses }

    var successRate: Double {
        totalLessonAttempts > 0 ? Double(correctAnswers) / Double(totalLessonAttempts) * 100 : 0
    }

    var estimatedLearningTime: Int {
        completedLessons.count * 10
    }

    // MARK: - Navigation

    func navigateToCourse(_ course: Course) {
        navigationPath.append(.courseDetail(course))
    }

    func navigateToLesson(_ lesson: Lesson, in course: Course) {
        navigationPath.append(.lesson(lesson, course))
    }

    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    // MARK: - Lesson Logic

    func selectCommand(_ option: CommandOption) {
        guard currentLessonState == .waiting else { return }
        isTyping = true
        userInput = ""

        let command = option.command
        for (i, char) in command.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                self.userInput.append(char)
                if i == command.count - 1 {
                    self.isTyping = false
                }
            }
        }
    }

    func executeQuest(_ quest: QuestLesson) {
        guard !userInput.isEmpty, currentLessonState == .waiting else { return }

        let trimmed = userInput.trimmingCharacters(in: .whitespaces)
        if trimmed == quest.answer {
            currentLessonState = .correct
            terminalOutput = quest.simulatedOutput
            addXP(50)
        } else {
            currentLessonState = .wrong
            terminalOutput = "bash: command not found: \(trimmed)"
        }
    }

    func executeScenarioStep(_ step: ScenarioStep) {
        guard !userInput.isEmpty, currentLessonState == .waiting else { return }

        let trimmed = userInput.trimmingCharacters(in: .whitespaces)
        if trimmed == step.answer {
            currentLessonState = .correct
            terminalOutput = step.simulatedOutput
            addXP(30)
        } else {
            currentLessonState = .wrong
            terminalOutput = "bash: command not found: \(trimmed)"
        }
    }

    func completeLesson(_ lesson: Lesson) {
        completedLessons.insert(lesson.id)
        addXP(100)
        streak += 1
        totalLessonAttempts += 1
        correctAnswers += 1
        currentLessonState = .completed
        checkAndUnlockAchievements()
    }

    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentLessonState = .waiting
            userInput = ""
            terminalOutput = ""
        }
    }

    func retry() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentLessonState = .waiting
            userInput = ""
            terminalOutput = ""
        }
    }

    func resetLesson() {
        currentLessonState = .waiting
        userInput = ""
        terminalOutput = ""
        showHint = false
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
        }
    }

    func checkAndUnlockAchievements() {
        for achievement in allAchievements {
            if !unlockedAchievements.contains(achievement.id) && achievement.condition(self) {
                unlockedAchievements.insert(achievement.id)
            }
        }
    }

    func getUnlockedBadges() -> [Achievement] {
        allAchievements.filter { unlockedAchievements.contains($0.id) }
    }
}
