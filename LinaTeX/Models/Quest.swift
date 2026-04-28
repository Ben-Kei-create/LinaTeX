import SwiftUI

// MARK: - Top-Level Models

enum CourseLevel: String, CaseIterable, Identifiable {
    case basics = "BASICS"
    case standard = "STANDARD"
    case advanced = "ADVANCED"

    var id: String { rawValue }

    var japanese: String {
        switch self {
        case .basics: return "基礎"
        case .standard: return "標準"
        case .advanced: return "実務応用"
        }
    }

    var gradient: [Color] {
        switch self {
        case .basics:   return [Color(hex: 0x2563EB), Color(hex: 0x10B981)]
        case .standard: return [Color(hex: 0x0EA5E9), Color(hex: 0x14B8A6)]
        case .advanced: return [Color(hex: 0x3B82F6), Color(hex: 0x059669)]
        }
    }

    var mainColor: Color {
        switch self {
        case .basics:   return Color(hex: 0x2563EB)
        case .standard: return Color(hex: 0x0EA5E9)
        case .advanced: return Color(hex: 0x059669)
        }
    }
}

struct Course: Identifiable, Hashable, Equatable {
    let id = UUID()
    let level: CourseLevel
    let title: String
    let subtitle: String
    let description: String
    let emoji: String
    let estimatedMinutes: Int
    let chapters: [Chapter]

    var totalLessons: Int { chapters.reduce(0) { $0 + $1.lessons.count } }

    static func == (lhs: Course, rhs: Course) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Chapter: Identifiable, Hashable, Equatable {
    let id = UUID()
    let number: Int
    let title: String
    let summary: String
    let lessons: [Lesson]

    static func == (lhs: Chapter, rhs: Chapter) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Lesson: Identifiable, Hashable, Equatable {
    let id = UUID()
    let title: String
    let emoji: String
    let estimatedMinutes: Int
    let content: LessonContent

    static func == (lhs: Lesson, rhs: Lesson) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Lesson Content Variants

enum LessonContent {
    case concept(ConceptLesson)
    case quest(QuestLesson)
    case scenario(ScenarioLesson)
    case quiz(QuizLesson)

    var typeLabel: String {
        switch self {
        case .concept:  return "READ"
        case .quest:    return "QUEST"
        case .scenario: return "SCENARIO"
        case .quiz:     return "QUIZ"
        }
    }

    var typeIcon: String {
        switch self {
        case .concept:  return "book.fill"
        case .quest:    return "target"
        case .scenario: return "flag.fill"
        case .quiz:     return "questionmark.circle.fill"
        }
    }
}

// MARK: - Learning Content

struct LearningMaterial {
    let title: String
    let description: String
    let content: String
    let sections: [LearningSection]
}

struct LearningSection {
    let heading: String
    let body: String
    let example: String?
    let tip: String?
}

struct DiagramContent {
    let title: String
    let ascii: String
    let explanation: String
}

struct ConceptLesson {
    let headline: String
    let sections: [ConceptSection]
}

struct ConceptSection: Identifiable {
    let id = UUID()
    let heading: String
    let body: String
    let codeSample: String?
    let tip: String?
}

struct QuestLesson {
    let scenario: String
    let prompt: String
    let hint: String
    let answer: String
    let options: [CommandOption]
    let simulatedOutput: String
    let successMessage: String
}

struct CommandOption: Identifiable {
    let id = UUID()
    let label: String
    let command: String
    let icon: String
}

struct ScenarioLesson {
    let setup: String
    let goal: String
    let steps: [ScenarioStep]
    let finaleMessage: String
}

struct ScenarioStep: Identifiable {
    let id = UUID()
    let prompt: String
    let hint: String
    let answer: String
    let options: [CommandOption]
    let simulatedOutput: String
}

struct QuizLesson {
    let questions: [QuizQuestion]
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let choices: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - Modern Theme Colors
struct ModernTheme {
    static let background = Color.white
    static let bgPrimary = Color.white
    static let bgSecondary = Color.white
    static let bgTertiary = Color(hex: 0xF1F5F9)

    static let bluePrimary = Color(hex: 0x2563EB)
    static let blueSecondary = Color(hex: 0x0EA5E9)
    static let emeraldPrimary = Color(hex: 0x059669)
    static let emeraldSecondary = Color(hex: 0x10B981)
    static let emeraldSoft = Color(hex: 0xD1FAE5)
    static let blueSoft = Color(hex: 0xDBEAFE)

    static let greenPrimary = emeraldPrimary
    static let greenSecondary = emeraldSecondary
    static let greenTertiary = Color(hex: 0x047857)

    static let textPrimary = Color(hex: 0x111827)
    static let textSecondary = Color(hex: 0x374151)
    static let textTertiary = Color(hex: 0x6B7280)
    static let textOnAccent = Color.white
    static let borderColor = Color(hex: 0xE5E7EB)

    static let terminalBackground = Color(hex: 0x0F172A)
    static let terminalSurface = Color(hex: 0x111827)
    static let terminalText = Color(hex: 0xE5E7EB)
    static let terminalMuted = Color(hex: 0x94A3B8)

    static let accentRed = Color(hex: 0xEF4444)
    static let accentYellow = Color(hex: 0xF59E0B)
    static let cardShadow = Color.black.opacity(0.07)
    static let buttonRadius: CGFloat = 8
    static let cardRadius: CGFloat = 8
}

typealias TerminalTheme = ModernTheme

// MARK: - Color helper

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8)  & 0xFF) / 255,
            blue:  Double( hex        & 0xFF) / 255,
            opacity: alpha
        )
    }
}
