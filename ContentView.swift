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
