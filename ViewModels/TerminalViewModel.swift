import SwiftUI

class TerminalViewModel: ObservableObject {
    @Published var commandHistory: [String] = []
    @Published var currentInput: String = ""
    @Published var output: String = ""

    let availableCommands: [Command] = [
        Command(name: "ls", icon: "list.bullet", command: "ls"),
        Command(name: "pwd", icon: "folder.fill", command: "pwd"),
        Command(name: "cd", icon: "chevron.right", command: "cd"),
        Command(name: "mkdir", icon: "folder.badge.plus", command: "mkdir"),
        Command(name: "touch", icon: "doc.badge.plus", command: "touch"),
        Command(name: "cat", icon: "doc.text", command: "cat"),
        Command(name: "rm", icon: "trash", command: "rm"),
        Command(name: "cp", icon: "doc.on.doc", command: "cp"),
        Command(name: "mv", icon: "arrow.right.doc", command: "mv"),
    ]

    func executeCommand(_ command: Command) {
        // Add command to current input with typewriter animation
        withAnimation(.easeInOut(duration: 0.3)) {
            currentInput = command.command
        }
    }

    func runCommand() {
        if !currentInput.isEmpty {
            // Move current input to history
            commandHistory.append(currentInput)

            // Get simulated output
            let result = getCommandOutput(currentInput)
            output = result

            // Clear current input
            currentInput = ""
        }
    }

    func clearInput() {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentInput = ""
        }
    }

    func clearTerminal() {
        withAnimation(.easeInOut(duration: 0.3)) {
            commandHistory.removeAll()
            output = ""
            currentInput = ""
        }
    }

    private func getCommandOutput(_ command: String) -> String {
        // Simulated command outputs
        let baseCommand = command.split(separator: " ").first.map(String.init) ?? ""

        switch baseCommand {
        case "ls":
            return "Desktop  Documents  Downloads  Pictures  Music  Videos"
        case "pwd":
            return "/home/user"
        case "cd":
            return ""  // cd has no output
        case "mkdir":
            return ""  // mkdir has no output on success
        case "touch":
            return ""  // touch has no output on success
        case "cat":
            return "Hello, Linux! 📖"
        case "rm":
            return ""  // rm has no output on success
        case "cp":
            return ""  // cp has no output on success
        case "mv":
            return ""  // mv has no output on success
        default:
            return "Command not found: \(command)"
        }
    }
}

struct Command: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let command: String
}
