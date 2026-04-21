import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TerminalViewModel()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.12, green: 0.12, blue: 0.18)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Image(systemName: "terminal.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                    Text("LinaTeX")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { viewModel.clearTerminal() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding(16)
                .background(Color(red: 0.08, green: 0.08, blue: 0.12))

                Divider()
                    .background(Color.green.opacity(0.3))

                // Terminal View
                TerminalView(
                    history: viewModel.commandHistory,
                    currentInput: viewModel.currentInput,
                    output: viewModel.output
                )
                .frame(maxHeight: .infinity)
                .padding(16)

                Divider()
                    .background(Color.green.opacity(0.3))

                // Level Selector
                HStack(spacing: 8) {
                    ForEach(CommandLevel.allCases, id: \.self) { level in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.currentLevel = level
                            }
                        }) {
                            Text(level.rawValue)
                                .font(.system(.caption, design: .monospaced))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(
                                    viewModel.currentLevel == level
                                        ? Color.green
                                        : Color.green.opacity(0.2)
                                )
                                .foregroundColor(
                                    viewModel.currentLevel == level
                                        ? .black
                                        : .green
                                )
                                .cornerRadius(6)
                        }
                    }
                }
                .padding(16)

                // Button Panel
                CommandButtonPanel(viewModel: viewModel)
                    .padding(16)
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}
