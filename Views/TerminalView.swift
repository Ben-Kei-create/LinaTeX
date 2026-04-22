import SwiftUI

struct TerminalView: View {
    let history: [String]
    let currentInput: String
    let output: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    // Command History
                    ForEach(history.indices, id: \.self) { index in
                        HStack(alignment: .top, spacing: 8) {
                            Text("$")
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                            Text(history[index])
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .font(.system(.body, design: .monospaced))
                        .id("history-\(index)")
                    }

                    // Current Input (Being typed)
                    if !currentInput.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Text("$")
                                .foregroundColor(.yellow)
                                .fontWeight(.semibold)
                            Text(currentInput)
                                .foregroundColor(.yellow)
                                .typewriterAnimation()
                            Spacer()
                        }
                        .font(.system(.body, design: .monospaced))
                        .id("current")
                    }

                    // Output
                    if !output.isEmpty {
                        Text(output)
                            .foregroundColor(.cyan)
                            .font(.system(.body, design: .monospaced))
                            .lineSpacing(2)
                            .id("output")
                    }

                    Spacer()
                }
                .onChange(of: history.count) { _ in
                    withAnimation {
                        proxy.scrollTo("output", anchor: .bottom)
                    }
                }
            }
            .background(Color(red: 0.08, green: 0.08, blue: 0.12))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// Typewriter animation modifier
struct TypewriterAnimationModifier: ViewModifier {
    @State private var displayedText: String = ""
    let fullText: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                animateTypewriter()
            }
    }

    private func animateTypewriter() {
        displayedText = ""
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                displayedText.append(character)
            }
        }
    }
}

extension View {
    func typewriterAnimation() -> some View {
        self.modifier(TypewriterAnimationModifier(fullText: ""))
    }
}

#Preview {
    TerminalView(
        history: ["ls -la", "pwd"],
        currentInput: "cd /home",
        output: "total 24\ndrwxr-xr-x  2 user user 4096 Apr 21 13:20 ."
    )
    .background(Color.black)
    .padding()
}
