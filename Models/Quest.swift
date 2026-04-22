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
        case .basics:   return [Color(hex: 0x22D3EE), Color(hex: 0x3B82F6)]
        case .standard: return [Color(hex: 0xA855F7), Color(hex: 0xEC4899)]
        case .advanced: return [Color(hex: 0xF97316), Color(hex: 0xEF4444)]
        }
    }

    var mainColor: Color {
        switch self {
        case .basics:   return Color(hex: 0x22D3EE)
        case .standard: return Color(hex: 0xA855F7)
        case .advanced: return Color(hex: 0xF97316)
        }
    }
}

struct Course: Identifiable {
    let id = UUID()
    let level: CourseLevel
    let title: String
    let subtitle: String
    let description: String
    let emoji: String
    let estimatedMinutes: Int
    let chapters: [Chapter]

    var totalLessons: Int { chapters.reduce(0) { $0 + $1.lessons.count } }
}

struct Chapter: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let summary: String
    let lessons: [Lesson]
}

struct Lesson: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let estimatedMinutes: Int
    let content: LessonContent
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
