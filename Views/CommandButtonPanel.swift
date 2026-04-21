import SwiftUI

struct CommandButtonPanel: View {
    @ObservedObject var viewModel: TerminalViewModel

    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        VStack(spacing: 12) {
            // Command Grid
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.availableCommands) { cmd in
                    CommandButton(
                        title: cmd.name,
                        icon: cmd.icon,
                        action: {
                            viewModel.executeCommand(cmd)
                        }
                    )
                }
            }

            // Execute Button
            HStack(spacing: 8) {
                Button(action: { viewModel.clearInput() }) {
                    Label("Clear", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.red.opacity(0.3))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                }

                Button(action: { viewModel.runCommand() }) {
                    Label("Execute", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.green)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .cornerRadius(8)
                }
            }
            .font(.system(.body, design: .monospaced))
        }
    }
}

struct CommandButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            action()
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.6, blue: 0.3),
                        Color(red: 0.15, green: 0.5, blue: 0.25)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

#Preview {
    CommandButtonPanel(viewModel: TerminalViewModel())
        .background(Color.black)
        .padding()
}
