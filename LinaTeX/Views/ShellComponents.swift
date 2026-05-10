import SwiftUI

extension TerminalTheme {
    static let background = bgPrimary
    static let cardRadius: CGFloat = 14
    static let cardShadow = Color.black.opacity(0.18)
}

struct ShellScreen<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            TerminalTheme.background.ignoresSafeArea()
            content
        }
    }
}

struct ShellHeader: View {
    let title: String
    let subtitle: String?
    let trailing: String
    let action: () -> Void

    init(title: String, subtitle: String? = nil, trailing: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
        self.action = action
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .shellFont(.headline, weight: .bold)
                    .foregroundColor(TerminalTheme.textPrimary)
                    .lineLimit(1)

                if let subtitle {
                    Text(subtitle)
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)

            Button(trailing, action: action)
                .buttonStyle(ShellButtonStyle(kind: .outline))
                .frame(width: 86, height: 36)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(TerminalTheme.bgSecondary)
        .overlay(Rectangle().fill(TerminalTheme.borderColor).frame(height: 1), alignment: .bottom)
    }
}

struct ShellPanel<Content: View>: View {
    let borderOpacity: Double
    let cornerRadius: CGFloat
    private let content: Content

    init(
        borderOpacity: Double = 0.2,
        cornerRadius: CGFloat = TerminalTheme.cardRadius,
        @ViewBuilder content: () -> Content
    ) {
        self.borderOpacity = borderOpacity
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TerminalTheme.bgSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(TerminalTheme.greenPrimary.opacity(borderOpacity), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

struct ShellSectionTitle: View {
    let title: String
    let subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .shellFont(.caption, weight: .bold)
                .foregroundColor(TerminalTheme.greenPrimary)
                .textCase(.uppercase)

            if let subtitle {
                Text(subtitle)
                    .shellFont(.caption2)
                    .foregroundColor(TerminalTheme.textTertiary)
                    .lineLimit(1)
            }
        }
    }
}

struct ShellProgressBar: View {
    let value: Double
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(TerminalTheme.bgTertiary)
                Capsule()
                    .fill(TerminalTheme.emeraldPrimary)
                    .frame(width: max(0, min(1, value)) * geometry.size.width)
            }
        }
        .frame(height: height)
    }
}

struct ShellButtonStyle: ButtonStyle {
    enum Kind {
        case filled
        case outline
    }

    var kind: Kind = .filled
    var isSelected = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shellFont(.caption, weight: .bold)
            .foregroundColor(foregroundColor)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.78)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: 42)
            .background(background)
            .overlay(
                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous))
            .opacity(configuration.isPressed ? 0.72 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }

    private var background: AnyShapeStyle {
        switch kind {
        case .filled:
            return AnyShapeStyle(LinearGradient(
                colors: [TerminalTheme.bluePrimary, TerminalTheme.emeraldPrimary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        case .outline:
            return AnyShapeStyle(isSelected ? TerminalTheme.emeraldPrimary.opacity(0.18) : TerminalTheme.bgTertiary.opacity(0.7))
        }
    }

    private var foregroundColor: Color {
        switch kind {
        case .filled:
            return TerminalTheme.textOnAccent
        case .outline:
            return isSelected ? TerminalTheme.greenPrimary : TerminalTheme.textPrimary
        }
    }

    private var borderColor: Color {
        isSelected ? TerminalTheme.greenPrimary.opacity(0.72) : TerminalTheme.borderColor
    }
}

extension View {
    func shellFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> some View {
        font(.system(style, design: .monospaced).weight(weight))
    }
}

struct ProblemBriefPanel: View {
    let title: String
    let subtitle: String?
    let text: String
    let detail: String

    init(title: String, subtitle: String? = nil, text: String, detail: String = "") {
        self.title = title
        self.subtitle = subtitle
        self.text = text
        self.detail = detail
    }

    var body: some View {
        ShellPanel(borderOpacity: 0.24) {
            VStack(alignment: .leading, spacing: 9) {
                ShellSectionTitle(title: title, subtitle: subtitle)

                Text(text)
                    .shellFont(.body, weight: .semibold)
                    .foregroundColor(TerminalTheme.textPrimary)
                    .lineLimit(4)
                    .lineSpacing(3)

                if !detail.isEmpty {
                    Text(detail)
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
    }
}

struct WordBankPanel: View {
    let arguments: [String]
    @Binding var selectedArgument: String?
    let options: [CommandOption]
    let selectedCommand: String
    let areArgumentsDisabled: Bool
    let areCommandsDisabled: Bool
    let commandAction: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ShellPanel(borderOpacity: 0.26) {
                VStack(alignment: .leading, spacing: 10) {
                    ShellSectionTitle(title: "COMMANDS")

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 112), spacing: 8)], alignment: .leading, spacing: 8) {
                        ForEach(options) { option in
                            Button {
                                commandAction(option.command)
                            } label: {
                                Label(option.label, systemImage: option.icon)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedCommand == option.command))
                            .disabled(areCommandsDisabled)
                        }
                    }
                }
            }

            if !arguments.isEmpty {
                ShellPanel(borderOpacity: 0.2) {
                    VStack(alignment: .leading, spacing: 10) {
                        ShellSectionTitle(title: "ARGUMENTS")

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 8)], alignment: .leading, spacing: 8) {
                            ForEach(arguments, id: \.self) { argument in
                                Button(argument) {
                                    selectedArgument = argument
                                }
                                .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedArgument == argument))
                                .disabled(areArgumentsDisabled)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ActionBar: View {
    let canRun: Bool
    let state: LessonState
    let completeLabel: String
    let runAction: () -> Void
    let retryAction: () -> Void
    let completeAction: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            if state == .wrong {
                Button("TRY AGAIN", action: retryAction)
                    .buttonStyle(ShellButtonStyle(kind: .outline))
            }

            if state == .correct {
                Button(completeLabel, action: completeAction)
                    .buttonStyle(ShellButtonStyle(kind: .filled))
            } else {
                Button("RUN", action: runAction)
                    .buttonStyle(ShellButtonStyle(kind: .filled))
                    .disabled(!canRun)
                    .opacity(canRun ? 1 : 0.42)
            }
        }
        .frame(height: 52)
    }
}

func normalizedCommandLine(_ commandLine: String) -> String {
    commandLine
        .split(whereSeparator: { $0.isWhitespace })
        .joined(separator: " ")
}

func terminalCommandLine(command: String, argument: String?, fallbackArgument: String?) -> String {
    let trimmedCommand = normalizedCommandLine(command)
    guard !trimmedCommand.isEmpty else { return "" }
    guard trimmedCommand.split(separator: " ").count == 1 else { return trimmedCommand }

    if let argument, !argument.isEmpty {
        return normalizedCommandLine("\(trimmedCommand) \(argument)")
    }

    if let fallbackArgument, !fallbackArgument.isEmpty {
        return normalizedCommandLine("\(trimmedCommand) \(fallbackArgument)")
    }

    return trimmedCommand
}

func meaningfulArgumentChoices(options: [CommandOption], answer: String) -> [String] {
    let normalizedAnswer = normalizedCommandLine(answer)
    let parts = normalizedAnswer.split(separator: " ", maxSplits: 1).map(String.init)
    guard parts.count == 2 else { return [] }

    if options.contains(where: { normalizedCommandLine($0.command) == normalizedAnswer }) {
        return []
    }

    let answerCommand = parts[0]
    var choices = [parts[1]]

    for option in options {
        let optionParts = normalizedCommandLine(option.command).split(separator: " ", maxSplits: 1).map(String.init)
        if optionParts.count == 2, optionParts[0] == answerCommand {
            choices.append(optionParts[1])
        }
    }

    return Array(Set(choices)).sorted()
}

func defaultArgument(for answer: String, visibleChoices: [String]) -> String? {
    let parts = normalizedCommandLine(answer).split(separator: " ", maxSplits: 1).map(String.init)
    guard parts.count == 2 else { return nil }
    return visibleChoices.count == 1 ? parts[1] : nil
}
