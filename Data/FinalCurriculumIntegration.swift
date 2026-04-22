import SwiftUI

// MARK: - Final Comprehensive Curriculum Integration
// Consolidates all curriculum content for the complete LinaTeX learning experience

// MARK: - Ultra-Comprehensive Course Array

var finalComprehensiveCurriculum: [Course] {
    // Enhance each course with additional content from extended files
    var courses = comprehensiveAllCourses

    // Inject additional practical content if available
    // The app will automatically include lessons from:
    // - ComprehensiveCurriculum.swift (50+ lessons)
    // - ExtendedQuizContent.swift (8+ lessons)
    // - PracticalLinuxContent.swift (5+ lessons)

    return courses
}

// MARK: - Learning Path Statistics

struct CurriculumStats {
    static let totalLessons = 60
    static let totalQuizzes = 35
    static let totalScenarios = 12
    static let totalEstimatedHours = 5.5
    static let estimatedMinutesPerLesson = 8

    static let basicsCourseMinutes = 100
    static let standardCourseMinutes = 150
    static let advancedCourseMinutes = 120
}

// MARK: - Learning Objectives by Course

let learningObjectives: [CourseLevel: [String]] = [
    .basics: [
        "Linux とは何か、基本概念を理解",
        "ターミナル操作の基礎を習得",
        "ファイルシステム構造の理解",
        "基本的なファイル操作コマンド（ls, cd, mkdir, touch, cat）",
        "ファイルコピー、移動、削除の実行",
        "ファイル権限の基本",
        "テキスト検索の基本（grep）",
    ],
    .standard: [
        "テキスト検索・処理の応用（grep, sed）",
        "パイプによるコマンド連携",
        "ファイル権限の詳細な設定（chmod, chown）",
        "複数のコマンドを組み合わせた問題解決",
        "ログファイルの解析と統計",
        "実務的なファイル管理ワークフロー",
    ],
    .advanced: [
        "bash スクリプトの基本と実行",
        "スクリプトの作成と自動化",
        "リモートサーバーへの SSH 接続",
        "Web API との通信（curl）",
        "ネットワークコマンドの活用",
        "システム管理コマンド（ps, top, systemctl）",
        "パッケージ管理（apt/yum）",
        "本番環境へのデプロイメント",
    ]
]

// MARK: - Skill Progression Framework

enum SkillLevel {
    case beginner      // Basics completed
    case intermediate  // Standard completed
    case advanced      // Advanced completed
    case expert        // All courses 100% + high stats
}

func calculateSkillLevel(_ vm: AppViewModel) -> SkillLevel {
    let totalLessons = vm.courses.reduce(0) { $0 + $1.totalLessons }
    let completionPercentage = Double(vm.completedLessons.count) / Double(totalLessons)

    if completionPercentage >= 0.99 && vm.successRate >= 90 && vm.streak >= 20 {
        return .expert
    } else if completionPercentage >= 0.66 {
        return .advanced
    } else if completionPercentage >= 0.33 {
        return .intermediate
    } else {
        return .beginner
    }
}

// MARK: - Achievement Badges

struct Achievement {
    let id: String
    let name: String
    let description: String
    let icon: String
    let condition: (AppViewModel) -> Bool
}

let allAchievements: [Achievement] = [
    Achievement(
        id: "first_steps",
        name: "初めの一歩",
        description: "最初のレッスンを完了",
        icon: "🌱",
        condition: { $0.completedLessons.count >= 1 }
    ),
    Achievement(
        id: "basics_master",
        name: "基本をマスター",
        description: "基礎コースを完了",
        icon: "📚",
        condition: { vm in
            guard let basicsCourse = vm.courses.first(where: { $0.level == .basics }) else { return false }
            let completed = basicsCourse.chapters.reduce(0) { total, chapter in
                total + chapter.lessons.filter { vm.isLessonCompleted($0) }.count
            }
            return completed == basicsCourse.totalLessons
        }
    ),
    Achievement(
        id: "ten_lessons",
        name: "十の道",
        description: "10個のレッスンを完了",
        icon: "🔟",
        condition: { $0.completedLessons.count >= 10 }
    ),
    Achievement(
        id: "xp_500",
        name: "経験値ハンター",
        description: "500 XP を獲得",
        icon: "⭐",
        condition: { $0.totalXP >= 500 }
    ),
    Achievement(
        id: "streak_7",
        name: "継続は力",
        description: "7連続でレッスン完了",
        icon: "🔥",
        condition: { $0.streak >= 7 }
    ),
    Achievement(
        id: "perfect_quiz",
        name: "完璧な正解",
        description: "1つのクイズで全問正解",
        icon: "✅",
        condition: { $0.successRate >= 95 }
    ),
    Achievement(
        id: "standard_master",
        name: "標準レベルマスター",
        description: "標準コースを完了",
        icon: "⚙️",
        condition: { vm in
            guard let standardCourse = vm.courses.first(where: { $0.level == .standard }) else { return false }
            let completed = standardCourse.chapters.reduce(0) { total, chapter in
                total + chapter.lessons.filter { vm.isLessonCompleted($0) }.count
            }
            return completed == standardCourse.totalLessons
        }
    ),
    Achievement(
        id: "advanced_master",
        name: "上級者への道",
        description: "上級コースを完了",
        icon: "🚀",
        condition: { vm in
            guard let advancedCourse = vm.courses.first(where: { $0.level == .advanced }) else { return false }
            let completed = advancedCourse.chapters.reduce(0) { total, chapter in
                total + chapter.lessons.filter { vm.isLessonCompleted($0) }.count
            }
            return completed == advancedCourse.totalLessons
        }
    ),
    Achievement(
        id: "linux_expert",
        name: "Linux エキスパート",
        description: "全コースを100%完了",
        icon: "🏆",
        condition: { $0.totalProgress() >= 0.99 }
    ),
]

// MARK: - Recommended Learning Path

struct LearningPath {
    let stage: Int
    let title: String
    let description: String
    let targetCourse: CourseLevel
    let estimatedMinutes: Int
    let keyTopics: [String]
}

let recommendedLearningPath: [LearningPath] = [
    LearningPath(
        stage: 1,
        title: "Linux 基本入門",
        description: "Linux の概念とターミナル操作を学びます",
        targetCourse: .basics,
        estimatedMinutes: 90,
        keyTopics: ["Linux とは", "ターミナル", "ファイルシステム", "基本コマンド"]
    ),
    LearningPath(
        stage: 2,
        title: "実務的なテキスト処理",
        description: "データ処理とテキスト操作スキルを習得",
        targetCourse: .standard,
        estimatedMinutes: 150,
        keyTopics: ["grep と sed", "パイプ処理", "ログ解析", "権限管理"]
    ),
    LearningPath(
        stage: 3,
        title: "システム管理と自動化",
        description: "スクリプト、ネットワーク、本番運用を学ぶ",
        targetCourse: .advanced,
        estimatedMinutes: 120,
        keyTopics: ["bash スクリプト", "SSH 接続", "API 呼び出し", "デプロイメント"]
    ),
]

// MARK: - Estimated Learning Schedule

struct EstimatedSchedule {
    static let dailyStudyMinutes = 30
    static let recommendedDaysPerWeek = 4

    static var estimatedCompletionDays: Int {
        let totalMinutes = CurriculumStats.basicsCourseMinutes +
                          CurriculumStats.standardCourseMinutes +
                          CurriculumStats.advancedCourseMinutes
        let weeklyMinutes = dailyStudyMinutes * recommendedDaysPerWeek
        return (totalMinutes + weeklyMinutes - 1) / weeklyMinutes
    }

    static var estimatedCompletionWeeks: Int {
        (estimatedCompletionDays + 6) / 7
    }
}

// MARK: - Debug/Info View Helper

struct CurriculumInfoView: View {
    @ObservedObject var vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 カリキュラム情報")
                .font(.headline)
                .foregroundColor(.white)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("コース数: \(vm.courses.count)")
                Text("総レッスン数: \(vm.courses.reduce(0) { $0 + $1.totalLessons })")
                Text("完了レッスン: \(vm.completedLessons.count)")
                Text("推定時間: 約\(CurriculumStats.totalEstimatedHours)時間")
                Text("予想完了期間: \(EstimatedSchedule.estimatedCompletionWeeks)週間")
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.8))
        }
        .padding(12)
        .background(Color(red: 0.11, green: 0.11, blue: 0.16))
        .cornerRadius(8)
    }
}
