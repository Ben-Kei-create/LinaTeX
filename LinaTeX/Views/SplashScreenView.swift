import SwiftUI

struct SplashScreenView: View {
    @State private var showComplete = false
    @State private var lines: [String] = []

    private let bootSequence = [
        "LINATEX / BOOT",
        "PROFILE: 6H LINUX PRACTICE",
        "INPUT: BUTTONS ONLY",
        "PALETTE: GREEN BLACK",
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
                    ForEach(lines, id: \.self) { line in
                        Text("> \(line)")
                            .shellFont(.caption, weight: line == "READY" ? .bold : .regular)
                            .foregroundColor(line == "READY" ? TerminalTheme.greenPrimary : TerminalTheme.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if showComplete {
                        HStack(spacing: 8) {
                            Text("user@linatex:~$")
                                .shellFont(.caption, weight: .bold)
                                .foregroundColor(TerminalTheme.greenPrimary)
                            CursorView()
                        }
                        .padding(.top, 10)
                        .transition(.opacity)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)

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
