import SwiftUI

struct SplashScreenView: View {
    @State private var showComplete = false
    @State private var lines: [String] = []

    private let bootSequence = [
        "LINATEX / BOOT",
        "PROFILE: 6H LINUX PRACTICE",
        "INPUT: BUTTONS ONLY",
        "PALETTE: BLUE EMERALD",
        "LOADING COURSE INDEX",
        "LOADING FILE RUNBOOKS",
        "LOADING SIMULATED SHELL",
        "READY"
    ]

    var body: some View {
        ShellScreen {
            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 8) {
                    Text("LinaTeX")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(TerminalTheme.textPrimary)
                        .padding(.bottom, 10)

                    ForEach(lines, id: \.self) { line in
                        Text("> \(line)")
                            .font(.system(.caption, design: .monospaced).weight(line == "READY" ? .bold : .regular))
                            .foregroundColor(line == "READY" ? TerminalTheme.greenPrimary : TerminalTheme.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if showComplete {
                        HStack(spacing: 8) {
                            Text("user@linatex:~$")
                                .font(.system(.caption, design: .monospaced).weight(.bold))
                                .foregroundColor(TerminalTheme.greenPrimary)
                            CursorView()
                        }
                        .padding(.top, 10)
                        .transition(.opacity)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(TerminalTheme.bgSecondary)
                .clipShape(RoundedRectangle(cornerRadius: TerminalTheme.cardRadius, style: .continuous))
                .shadow(color: TerminalTheme.cardShadow, radius: 16, x: 0, y: 8)
                .padding(20)

                Spacer(minLength: 0)
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
                withAnimation(.easeOut(duration: 0.18)) {
                    lines.append(line)
                }

                if index == bootSequence.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showComplete = true
                        }
                    }
                }
            }
            delay += 0.09
        }
    }
}

#Preview {
    SplashScreenView()
}
