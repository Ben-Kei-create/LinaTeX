import SwiftUI

enum CommandLevel: String, CaseIterable {
    case basic = "Basic"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

class TerminalViewModel: ObservableObject {
    @Published var commandHistory: [String] = []
    @Published var currentInput: String = ""
    @Published var output: String = ""
    @Published var currentLevel: CommandLevel = .basic

    let allCommands: [Command] = [
        // Basic Level
        Command(name: "ls", icon: "list.bullet", command: "ls", level: .basic, description: "List directory contents"),
        Command(name: "pwd", icon: "folder.fill", command: "pwd", level: .basic, description: "Print working directory"),
        Command(name: "cd", icon: "chevron.right", command: "cd", level: .basic, description: "Change directory"),
        Command(name: "mkdir", icon: "folder.badge.plus", command: "mkdir", level: .basic, description: "Make directory"),
        Command(name: "touch", icon: "doc.badge.plus", command: "touch", level: .basic, description: "Create file"),
        Command(name: "cat", icon: "doc.text", command: "cat", level: .basic, description: "Display file contents"),

        // Intermediate Level
        Command(name: "rm", icon: "trash", command: "rm", level: .intermediate, description: "Remove file"),
        Command(name: "cp", icon: "doc.on.doc", command: "cp", level: .intermediate, description: "Copy file"),
        Command(name: "mv", icon: "arrow.right.doc", command: "mv", level: .intermediate, description: "Move/rename file"),
        Command(name: "grep", icon: "magnifyingglass", command: "grep", level: .intermediate, description: "Search text"),
        Command(name: "echo", icon: "quote.bubble", command: "echo", level: .intermediate, description: "Print text"),
        Command(name: "find", icon: "magnifyingglass.circle", command: "find", level: .intermediate, description: "Find files"),

        // Advanced Level
        Command(name: "chmod", icon: "lock", command: "chmod", level: .advanced, description: "Change permissions"),
        Command(name: "tar", icon: "archivebox", command: "tar", level: .advanced, description: "Archive files"),
        Command(name: "ssh", icon: "network", command: "ssh", level: .advanced, description: "Remote connection"),
        Command(name: "pipe", icon: "arrowtriangle.right", command: "| (pipe)", level: .advanced, description: "Pipe commands"),
    ]

    var availableCommands: [Command] {
        allCommands.filter { $0.level == currentLevel }
    }

    func executeCommand(_ command: Command) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentInput = command.command
        }
    }

    func runCommand() {
        if !currentInput.isEmpty {
            commandHistory.append(currentInput)

            let result = getCommandOutput(currentInput)
            output = result

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
    let level: CommandLevel
    let description: String
}
