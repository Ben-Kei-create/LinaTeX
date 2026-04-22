import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TerminalViewModel()

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.1).ignoresSafeArea()

            if vm.questState == .completed {
                CompletionView()
            } else {
                VStack(spacing: 0) {
                    HeaderView(vm: vm)
                    QuestCardView(vm: vm)
                    TerminalOutputView(vm: vm)
                    CommandPanelView(vm: vm)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Header
struct HeaderView: View {
    @ObservedObject var vm: TerminalViewModel

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "terminal.fill")
                    .foregroundColor(vm.currentQuest.accentColor)
                Text("LinaTeX")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Text("\(vm.currentQuestIndex + 1) / \(vm.totalQuests)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.gray)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 4)
                    Capsule()
                        .fill(vm.currentQuest.accentColor)
                        .frame(width: geo.size.width * vm.progress, height: 4)
                        .animation(.easeInOut(duration: 0.5), value: vm.progress)
                }
            }
            .frame(height: 4)
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.14))
    }
}

// MARK: - Quest Card
struct QuestCardView: View {
    @ObservedObject var vm: TerminalViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(vm.currentQuest.emoji)
                    .font(.system(size: 32))
                VStack(alignment: .leading, spacing: 2) {
                    Text("QUEST \(vm.currentQuestIndex + 1)")
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(vm.currentQuest.accentColor)
                        .fontWeight(.bold)
                    Text(vm.currentQuest.title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        vm.showHint.toggle()
                    }
                }) {
                    Image(systemName: "lightbulb\(vm.showHint ? ".fill" : "")")
                        .foregroundColor(.yellow.opacity(vm.showHint ? 1 : 0.5))
                        .font(.title3)
                }
            }

            Text(vm.currentQuest.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)

            if vm.showHint {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(vm.currentQuest.hint)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                .padding(10)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.16))
        )
        .overlay(
            Rectangle()
                .frame(width: 3)
                .foregroundColor(vm.currentQuest.accentColor),
            alignment: .leading
        )
    }
}

// MARK: - Terminal Output
struct TerminalOutputView: View {
    @ObservedObject var vm: TerminalViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle().fill(.red).frame(width: 8, height: 8)
                Circle().fill(.yellow).frame(width: 8, height: 8)
                Circle().fill(.green).frame(width: 8, height: 8)
                Spacer()
                Text("terminal")
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(.gray)
            }

            HStack(alignment: .bottom, spacing: 6) {
                Text("user@linux:~$")
                    .foregroundColor(.green.opacity(0.7))
                    .font(.system(.body, design: .monospaced))

                Text(vm.currentInput)
                    .foregroundColor(inputColor)
                    .font(.system(.body, design: .monospaced))

                if vm.questState == .waiting {
                    CursorView()
                }

                Spacer()
            }

            if !vm.terminalOutput.isEmpty {
                Text(vm.terminalOutput)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(vm.questState == .wrong ? .red.opacity(0.8) : .cyan)
                    .padding(.top, 2)
            }

            if vm.questState == .correct {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(vm.currentQuest.successMessage)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.green)
                }
                .padding(.top, 4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if vm.questState == .wrong {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text("ちがうよ！もう一度やってみよう 💪")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.red)
                }
                .padding(.top, 4)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.06, green: 0.06, blue: 0.08))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .animation(.easeInOut(duration: 0.3), value: vm.questState)
    }

    var inputColor: Color {
        switch vm.questState {
        case .correct: return .green
        case .wrong: return .red
        default: return .white
        }
    }
}

// MARK: - Cursor
struct CursorView: View {
    @State private var visible = true
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 8, height: 16)
            .opacity(visible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                    visible.toggle()
                }
            }
    }
}

// MARK: - Command Panel
struct CommandPanelView: View {
    @ObservedObject var vm: TerminalViewModel

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                ForEach(vm.currentQuest.commandOptions) { option in
                    CommandOptionButton(
                        option: option,
                        accentColor: vm.currentQuest.accentColor,
                        isSelected: vm.currentInput == option.command,
                        isDisabled: vm.questState != .waiting
                    ) {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        vm.selectCommand(option)
                    }
                }
            }

            if vm.questState == .waiting || vm.questState == .wrong {
                HStack(spacing: 10) {
                    if vm.questState == .wrong {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            vm.retry()
                        }) {
                            Label("もう一度", systemImage: "arrow.counterclockwise")
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(12)
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.semibold)
                        }
                    }

                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .heavy)
                        impact.impactOccurred()
                        vm.execute()
                    }) {
                        Label("実行する", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(vm.currentInput.isEmpty ? Color.gray.opacity(0.2) : vm.currentQuest.accentColor)
                            .foregroundColor(vm.currentInput.isEmpty ? .gray : .black)
                            .cornerRadius(12)
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.bold)
                    }
                    .disabled(vm.currentInput.isEmpty)
                }
            }

            if vm.questState == .correct {
                Button(action: {
                    let impact = UINotificationFeedbackGenerator()
                    impact.notificationOccurred(.success)
                    vm.nextQuest()
                }) {
                    Label("次の問題へ", systemImage: "arrow.right.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(
                            LinearGradient(
                                colors: [vm.currentQuest.accentColor, vm.currentQuest.accentColor.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.bold)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.14))
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.questState)
    }
}

// MARK: - Command Option Button
struct CommandOptionButton: View {
    let option: Quest.CommandOption
    let accentColor: Color
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            action()
        }) {
            VStack(spacing: 6) {
                Image(systemName: option.icon)
                    .font(.system(size: 20))
                Text(option.label)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected
                        ? accentColor.opacity(0.3)
                        : Color.white.opacity(0.06)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? accentColor : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
            .foregroundColor(isSelected ? accentColor : .white.opacity(0.7))
            .scaleEffect(isPressed ? 0.94 : 1.0)
        }
        .disabled(isDisabled)
        .opacity(isDisabled && !isSelected ? 0.4 : 1.0)
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @State private var scale: CGFloat = 0.5

    var body: some View {
        VStack(spacing: 24) {
            Text("🎉")
                .font(.system(size: 80))
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                        scale = 1.0
                    }
                }

            Text("クリア！")
                .font(.system(.largeTitle, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("全\(allQuests.count)問のLinuxコマンドを\nマスターしたよ！")
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.7))

            VStack(alignment: .leading, spacing: 8) {
                ForEach(allQuests) { quest in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("\(quest.emoji) \(quest.title)")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
        .padding(24)
    }
}

#Preview {
    ContentView()
}
