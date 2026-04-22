import SwiftUI

// MARK: - Learning Style Analysis

enum LearningStyle {
    case conceptPreferred    // コンセプト型が得意（理論系）
    case questPreferred      // クエスト型が得意（単純タスク系）
    case scenarioPreferred   // シナリオ型が得意（複合タスク系）
    case quizPreferred       // クイズ型が得意（知識確認系）
    case balanced            // バランス型
}

enum LearningPace {
    case slow               // 進度が遅い（復習が必要）
    case normal             // 通常ペース
    case fast               // 進度が速い（難易度アップ可能）
}

// MARK: - User Learning Profile

struct LearningProfile {
    let userId: UUID
    let learningStyle: LearningStyle
    let pace: LearningPace
    let successRates: [String: Double]  // ["grep": 0.85, "chmod": 0.45]
    let weakTopics: [String]             // ["chmod", "sed"]
    let strongTopics: [String]           // ["ls", "cd"]
    let conceptsToReview: [String]       // 復習が必要なトピック
    let estimatedCompletionDays: Int
}

// MARK: - Learning Path Analyzer

class LearningPathAnalyzer {

    static func analyzeUserProfile(_ vm: AppViewModel) -> LearningProfile {
        let style = detectLearningStyle(vm)
        let pace = calculateLearningPace(vm)
        let successRates = calculateTopicSuccessRates(vm)
        let weakTopics = identifyWeakTopics(successRates)
        let strongTopics = identifyStrongTopics(successRates)
        let conceptsToReview = findConceptsNeedingReview(vm, weakTopics)
        let completionDays = estimateCompletionDays(vm)

        return LearningProfile(
            userId: UUID(),
            learningStyle: style,
            pace: pace,
            successRates: successRates,
            weakTopics: weakTopics,
            strongTopics: strongTopics,
            conceptsToReview: conceptsToReview,
            estimatedCompletionDays: completionDays
        )
    }

    // MARK: - Learning Style Detection

    private static func detectLearningStyle(_ vm: AppViewModel) -> LearningStyle {
        guard vm.totalLessonAttempts > 5 else { return .balanced }

        // レッスンタイプ別の成功率を計算（簡易版）
        let completedCount = vm.completedLessons.count
        let successRate = vm.successRate

        // コンセプト型が多いなら、ユーザーは理論を好む傾向
        // シナリオ型が多いなら、実践的なタスクを好む傾向

        // 簡易判定：成功率と試行回数から推定
        if successRate > 85 && completedCount > 20 {
            return .scenarioPreferred  // 複雑なタスクで成功してる → 高度なシナリオ好き
        } else if successRate < 60 && completedCount > 10 {
            return .conceptPreferred   // 成功率低い → もっと理論的な学習が必要
        } else if vm.streak > 10 {
            return .quizPreferred      // 継続的 → クイズで確認したい
        } else {
            return .balanced
        }
    }

    // MARK: - Learning Pace Calculation

    private static func calculateLearningPace(_ vm: AppViewModel) -> LearningPace {
        let completedPerDay = Double(vm.completedLessons.count) / max(1, Double(max(1, EstimatedSchedule.estimatedCompletionDays)))

        if completedPerDay > 2.0 {
            return .fast
        } else if completedPerDay < 0.5 {
            return .slow
        } else {
            return .normal
        }
    }

    // MARK: - Topic Success Rate Analysis

    private static func calculateTopicSuccessRates(_ vm: AppViewModel) -> [String: Double] {
        // トピックごとの成功率を推定
        let topics = [
            "pwd/ls/cd", "mkdir/touch", "cat/cp/mv/rm", "grep", "sed",
            "chmod/chown", "ssh", "curl", "bash", "pipes"
        ]

        var rates: [String: Double] = [:]

        // 簡易的なトピック別成功率計算
        // 実際にはレッスンのメタデータからトピック抽出
        for topic in topics {
            // ベース成功率 + ランダム変動
            let baseRate = vm.successRate / 100.0
            let variation = Double.random(in: -0.15...0.15)
            rates[topic] = max(0, min(1, baseRate + variation))
        }

        return rates
    }

    // MARK: - Weak Topics Identification

    private static func identifyWeakTopics(_ successRates: [String: Double]) -> [String] {
        return successRates
            .filter { $0.value < 0.65 }
            .sorted { $0.value < $1.value }
            .map { $0.key }
            .prefix(5)
            .map(String.init)
    }

    // MARK: - Strong Topics Identification

    private static func identifyStrongTopics(_ successRates: [String: Double]) -> [String] {
        return successRates
            .filter { $0.value >= 0.80 }
            .sorted { $0.value > $1.value }
            .map { $0.key }
    }

    // MARK: - Review Concepts Detection

    private static func findConceptsNeedingReview(_ vm: AppViewModel, _ weakTopics: [String]) -> [String] {
        // 弱点トピックに関連する基礎コンセプト
        let conceptMap: [String: [String]] = [
            "grep": ["ファイルシステム", "正規表現", "パイプ"],
            "sed": ["テキスト処理", "正規表現", "パイプ"],
            "chmod": ["ファイル権限", "ユーザー管理", "セキュリティ"],
            "ssh": ["ネットワーク", "認証", "セキュリティ"],
            "bash": ["シェルの基本", "変数", "条件分岐"]
        ]

        var concepts: Set<String> = []
        for topic in weakTopics {
            if let relatedConcepts = conceptMap[topic] {
                concepts.formUnion(relatedConcepts)
            }
        }
        return Array(concepts)
    }

    // MARK: - Completion Time Estimation

    private static func estimateCompletionDays(_ vm: AppViewModel) -> Int {
        let remainingLessons = vm.courses.reduce(0) { $0 + $1.totalLessons } - vm.completedLessons.count
        let avgLessonsPerDay = max(0.5, Double(vm.completedLessons.count) / max(1, Double(7)))  // 過去7日間のペース（簡略版）
        return Int(ceil(Double(remainingLessons) / avgLessonsPerDay))
    }
}

// MARK: - Adaptive Path Generator

class AdaptivePathGenerator {

    static func generateNextLessons(_ vm: AppViewModel, count: Int = 3) -> [Lesson] {
        let profile = LearningPathAnalyzer.analyzeUserProfile(vm)

        var candidates: [Lesson] = []

        // 1. 弱点トピックの復習レッスンを優先
        for weakTopic in profile.weakTopics.prefix(2) {
            if let lesson = findLessonByTopic(vm.courses, weakTopic) {
                candidates.append(lesson)
            }
        }

        // 2. 学習スタイルに合ったレッスンを推奨
        let styleFocusedLessons = selectByLearningStyle(vm.courses, profile.learningStyle)
        candidates.append(contentsOf: styleFocusedLessons.prefix(count - candidates.count))

        // 3. 難易度を学習ペースに合わせる
        let paceAdjustedLessons = adjustDifficultyByPace(candidates, profile.pace)

        return Array(paceAdjustedLessons.prefix(count))
    }

    // MARK: - Topic-based Lesson Selection

    private static func findLessonByTopic(_ courses: [Course], _ topic: String) -> Lesson? {
        for course in courses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    if lesson.title.contains(topic) {
                        return lesson
                    }
                }
            }
        }
        return nil
    }

    // MARK: - Learning Style-based Selection

    private static func selectByLearningStyle(_ courses: [Course], _ style: LearningStyle) -> [Lesson] {
        var lessons: [Lesson] = []

        for course in courses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    let contentType = lesson.content
                    let matches = matchesStyle(contentType, style)
                    if matches {
                        lessons.append(lesson)
                    }
                }
            }
        }

        return lessons
    }

    private static func matchesStyle(_ content: LessonContent, _ style: LearningStyle) -> Bool {
        switch (content, style) {
        case (.concept, .conceptPreferred):
            return true
        case (.quest, .questPreferred):
            return true
        case (.scenario, .scenarioPreferred):
            return true
        case (.quiz, .quizPreferred):
            return true
        case (_, .balanced):
            return true
        default:
            return false
        }
    }

    // MARK: - Difficulty Adjustment

    private static func adjustDifficultyByPace(_ lessons: [Lesson], _ pace: LearningPace) -> [Lesson] {
        switch pace {
        case .fast:
            // 難易度の高いレッスンを前に配置
            return lessons.sorted { $0.estimatedMinutes > $1.estimatedMinutes }
        case .slow:
            // 復習と基礎を前に配置
            return lessons.sorted { $0.estimatedMinutes < $1.estimatedMinutes }
        case .normal:
            // そのまま
            return lessons
        }
    }
}

// MARK: - Recommendation Display Helper

struct PersonalizedRecommendation {
    let title: String
    let reason: String
    let lessons: [Lesson]
    let priority: Int  // 1: 高, 2: 中, 3: 低
}

class RecommendationEngine {

    static func getRecommendation(_ vm: AppViewModel) -> PersonalizedRecommendation? {
        let profile = LearningPathAnalyzer.analyzeUserProfile(vm)

        // 弱点トピックがある場合、優先的に推奨
        if !profile.weakTopics.isEmpty {
            let weakTopic = profile.weakTopics.first ?? "基本"
            let lessons = AdaptivePathGenerator.generateNextLessons(vm, count: 1)

            return PersonalizedRecommendation(
                title: "⚠️ \(weakTopic)を復習しよう",
                reason: "成功率が低い分野です。今が習得のチャンス！",
                lessons: lessons,
                priority: 1
            )
        }

        // ペースが遅い場合
        if profile.pace == .slow {
            let lessons = AdaptivePathGenerator.generateNextLessons(vm, count: 2)
            return PersonalizedRecommendation(
                title: "🚀 ペースアップチャレンジ",
                reason: "短いレッスンから始めて、ペースを上げませんか？",
                lessons: lessons,
                priority: 2
            )
        }

        // 通常の推奨
        let lessons = AdaptivePathGenerator.generateNextLessons(vm, count: 3)
        return PersonalizedRecommendation(
            title: "📚 次のレッスン",
            reason: "あなたの学習スタイルに合わせて選びました",
            lessons: lessons,
            priority: 3
        )
    }
}
