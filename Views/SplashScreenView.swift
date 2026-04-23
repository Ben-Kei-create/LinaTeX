import SwiftUI

struct SplashScreenView: View {
    @State private var bootText = ""
    @State private var showComplete = false
    @State private var lines: [String] = []

    let bootSequence = [
        "▇▆▅▄▃▂▁",
        "LinaTeX v1.0.0",
        "",
        "$ boot --shell",
        "Initializing kernel...",
        "Loading modules...",
        "Starting shell environment...",
        "",
        "Welcome to LinaTeX",
        "Type 'help' for commands",
        "",
        "fumiaki@linatex:~$ "
    ]

    var body: some View {
        ZStack {
            TerminalTheme.bgPrimary.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(lines, id: \.self) { line in
                            Text(line)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(TerminalTheme.greenPrimary)
                                .lineLimit(1)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if showComplete {
                    HStack(spacing: 4) {
                        Text("▸")
                            .foregroundColor(TerminalTheme.greenPrimary)
                            .opacity(bootText.isEmpty ? 0.3 : 1)
                            .animation(.easeInOut(duration: 0.6).repeatForever(), value: bootText)
                        Spacer()
                    }
                    .padding(16)
                }
            }
        }
        .onAppear {
            simulateBoot()
        }
    }

    private func simulateBoot() {
        var delay: Double = 0

        for (index, line) in bootSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                lines.append(line)
                if index == bootSequence.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showComplete = true
                    }
                }
            }
            delay += 0.08
        }
    }
}

#Preview {
    SplashScreenView()
}
