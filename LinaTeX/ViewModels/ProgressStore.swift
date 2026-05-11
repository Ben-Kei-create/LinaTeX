import Foundation

// Persists all user progress to UserDefaults so nothing is lost on app close.
final class ProgressStore {
    static let shared = ProgressStore()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let completedLessonIDs = "lt_completedLessonIDs"
        static let totalXP            = "lt_totalXP"
        static let streak             = "lt_streak"
        static let lastStudyDate      = "lt_lastStudyDate"
        static let unlockedAchievementIDs = "lt_unlockedAchievementIDs"
        static let totalLessonAttempts = "lt_totalLessonAttempts"
        static let correctAnswers      = "lt_correctAnswers"
    }

    var completedLessonIDs: Set<String> {
        get { Set(defaults.stringArray(forKey: Keys.completedLessonIDs) ?? []) }
        set { defaults.set(Array(newValue), forKey: Keys.completedLessonIDs) }
    }

    var totalXP: Int {
        get { defaults.integer(forKey: Keys.totalXP) }
        set { defaults.set(newValue, forKey: Keys.totalXP) }
    }

    var streak: Int {
        get { defaults.integer(forKey: Keys.streak) }
        set { defaults.set(newValue, forKey: Keys.streak) }
    }

    var lastStudyDate: Date? {
        get { defaults.object(forKey: Keys.lastStudyDate) as? Date }
        set { defaults.set(newValue, forKey: Keys.lastStudyDate) }
    }

    var unlockedAchievementIDs: Set<String> {
        get { Set(defaults.stringArray(forKey: Keys.unlockedAchievementIDs) ?? []) }
        set { defaults.set(Array(newValue), forKey: Keys.unlockedAchievementIDs) }
    }

    var totalLessonAttempts: Int {
        get { defaults.integer(forKey: Keys.totalLessonAttempts) }
        set { defaults.set(newValue, forKey: Keys.totalLessonAttempts) }
    }

    var correctAnswers: Int {
        get { defaults.integer(forKey: Keys.correctAnswers) }
        set { defaults.set(newValue, forKey: Keys.correctAnswers) }
    }
}
