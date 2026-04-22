import SwiftUI
import Combine

enum QuestState {
    case waiting
    case correct
    case wrong
    case completed
}

class TerminalViewModel: ObservableObject {
    @Published var currentQuestIndex: Int = 0
    @Published var questState: QuestState = .waiting
    @Published var currentInput: String = ""
    @Published var terminalOutput: String = ""
    @Published var showHint: Bool = false
    @Published var isTyping: Bool = false

    var currentQuest: Quest { allQuests[currentQuestIndex] }
    var totalQuests: Int { allQuests.count }
    var progress: Double { Double(currentQuestIndex) / Double(totalQuests) }

    func selectCommand(_ option: Quest.CommandOption) {
        guard questState == .waiting else { return }
        isTyping = true
        currentInput = ""

        // タイプライター効果
        let command = option.command
        for (i, char) in command.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.06) {
                self.currentInput.append(char)
                if i == command.count - 1 {
                    self.isTyping = false
                }
            }
        }
    }

    func execute() {
        guard !currentInput.isEmpty, questState == .waiting else { return }

        let trimmed = currentInput.trimmingCharacters(in: .whitespaces)
        if trimmed == currentQuest.answer {
            questState = .correct
            terminalOutput = currentQuest.outputSimulation
        } else {
            questState = .wrong
            terminalOutput = "bash: command not found: \(trimmed)"
        }
    }

    func nextQuest() {
        if currentQuestIndex < allQuests.count - 1 {
            withAnimation(.easeInOut(duration: 0.4)) {
                currentQuestIndex += 1
                questState = .waiting
                currentInput = ""
                terminalOutput = ""
                showHint = false
            }
        } else {
            questState = .completed
        }
    }

    func retry() {
        withAnimation(.easeInOut(duration: 0.3)) {
            questState = .waiting
            currentInput = ""
            terminalOutput = ""
        }
    }
}
