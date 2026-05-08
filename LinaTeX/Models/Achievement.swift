import Foundation

enum LessonType {
    case concept
    case quest
    case scenario
    case quiz
}

struct Achievement: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let requirement: AchievementRequirement
    let unlockedDate: Date?

    init(
        id: String,
        name: String,
        description: String,
        icon: String,
        requirement: AchievementRequirement,
        unlockedDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.unlockedDate = unlockedDate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        lhs.id == rhs.id
    }
}

enum AchievementRequirement {
    case lessonsCompleted(Int)
    case xpReached(Int)
    case streakDays(Int)
    case successRate(Double)
    case courseCompleted(String)
    case firstLesson
    case allConceptLessons
    case allQuestLessons
    case allScenarioLessons
}

let allAchievements: [Achievement] = [
    Achievement(
        id: "first_step",
        name: "最初の一歩",
        description: "最初のレッスンを完了",
        icon: "🎯",
        requirement: .firstLesson
    ),
    Achievement(
        id: "lesson_master",
        name: "レッスンマスター",
        description: "10個のレッスンを完了",
        icon: "📚",
        requirement: .lessonsCompleted(10)
    ),
    Achievement(
        id: "xp_collector",
        name: "XP コレクター",
        description: "500 XP を獲得",
        icon: "⭐",
        requirement: .xpReached(500)
    ),
    Achievement(
        id: "consistent_learner",
        name: "継続学習者",
        description: "7 日間のストリークを達成",
        icon: "🔥",
        requirement: .streakDays(7)
    ),
    Achievement(
        id: "accuracy_expert",
        name: "精度エキスパート",
        description: "90% の成功率を達成",
        icon: "🎯",
        requirement: .successRate(90)
    ),
    Achievement(
        id: "concept_master",
        name: "コンセプトマスター",
        description: "すべてのコンセプトレッスンを完了",
        icon: "💡",
        requirement: .allConceptLessons
    ),
    Achievement(
        id: "quest_complete",
        name: "クエスト完全制覇",
        description: "すべてのクエストを完了",
        icon: "⚔️",
        requirement: .allQuestLessons
    ),
    Achievement(
        id: "scenario_solver",
        name: "シナリオソルバー",
        description: "すべてのシナリオを完了",
        icon: "🗺️",
        requirement: .allScenarioLessons
    ),
    Achievement(
        id: "legend_status",
        name: "レジェンドステータス",
        description: "1000 XP を獲得",
        icon: "👑",
        requirement: .xpReached(1000)
    ),
]
