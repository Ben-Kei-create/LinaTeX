import SwiftUI

// MARK: - Action Style

enum ActionStyle {
    case primary
    case secondary
    case success
    case danger
}

// MARK: - Primary Action Button

struct PrimaryActionButton: View {
    let title: String
    let icon: String
    var style: ActionStyle = .primary
    var color: Color = ModernTheme.primary
    var disabled: Bool = false
    let action: () -> Void

    var fillColor: Color {
        if disabled { return ModernTheme.borderStrong }
        switch style {
        case .primary: return color
        case .secondary: return ModernTheme.bgSubtle
        case .success: return ModernTheme.success
        case .danger: return ModernTheme.danger
        }
    }

    var foregroundColor: Color {
        if disabled { return .white }
        switch style {
        case .primary, .success, .danger: return .white
        case .secondary: return ModernTheme.textPrimary
        }
    }

    var shadowColor: Color {
        if disabled { return .clear }
        switch style {
        case .primary: return color.opacity(0.35)
        case .success: return ModernTheme.success.opacity(0.35)
        case .danger: return ModernTheme.danger.opacity(0.35)
        case .secondary: return .clear
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(title)
                    .font(ModernFont.bodyEmphasizedSmall)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(fillColor)
            )
            .foregroundColor(foregroundColor)
            .shadow(color: shadowColor, radius: 6, x: 0, y: 2)
        }
        .disabled(disabled)
    }
}

// LinaTeXProAdBanner was removed. Use AdBannerView instead.

// MARK: - Problem Presentation

struct ProblemInstructionCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    var badge: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(color.opacity(0.12))
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color)
                }

                Text(title)
                    .font(ModernFont.headlineSmall)
                    .foregroundColor(ModernTheme.textPrimary)

                Spacer()

                if let badge {
                    Text(badge)
                        .font(ModernFont.labelSmall)
                        .foregroundColor(color)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(color.opacity(0.12)))
                }
            }

            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ModernTheme.border, lineWidth: 1)
        )
        .overlay(
            Rectangle()
                .fill(color)
                .frame(width: 4),
            alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
    }
}

struct CommandChoiceSection: View {
    let title: String
    var subtitle: String?
    let options: [CommandOption]
    let selectedCommand: String
    let accentColor: Color
    let isDisabled: Bool
    let action: (CommandOption) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(ModernFont.labelMedium)
                    .foregroundColor(ModernTheme.textSecondary)
                if let subtitle {
                    Text(subtitle)
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textTertiary)
                }
            }

            VStack(spacing: 8) {
                ForEach(options) { option in
                    CommandButton(
                        option: option,
                        accentColor: accentColor,
                        isSelected: selectedCommand == option.command,
                        isDisabled: isDisabled
                    ) {
                        action(option)
                    }
                }
            }
        }
    }
}

struct ArgumentChoiceSection: View {
    let title: String
    let arguments: [String]
    let selectedArgument: String?
    let accentColor: Color
    let isDisabled: Bool
    let action: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(ModernFont.labelMedium)
                .foregroundColor(ModernTheme.textSecondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 112), spacing: 8)], alignment: .leading, spacing: 8) {
                ForEach(arguments, id: \.self) { argument in
                    Button {
                        action(argument)
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: selectedArgument == argument ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(selectedArgument == argument ? accentColor : ModernTheme.textTertiary)
                            Text(argument)
                                .font(ModernFont.codeSmall)
                                .foregroundColor(ModernTheme.textPrimary)
                                .lineLimit(2)
                                .minimumScaleFactor(0.82)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 9)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedArgument == argument ? accentColor.opacity(0.06) : ModernTheme.bgSubtle)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedArgument == argument ? accentColor : ModernTheme.border, lineWidth: selectedArgument == argument ? 1.2 : 0.5)
                    )
                    .disabled(isDisabled)
                    .opacity(isDisabled ? 0.5 : 1.0)
                }
            }
        }
    }
}

// MARK: - Command Button (Modern Light)

struct CommandButton: View {
    let option: CommandOption
    let accentColor: Color
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? accentColor : ModernTheme.border, lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                    if isSelected {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 9, height: 9)
                    }
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(option.label)
                        .font(ModernFont.codeSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(1)
                    if option.icon != "circle" {
                        HStack(spacing: 4) {
                            Image(systemName: option.icon)
                                .font(.system(size: 9, weight: .semibold))
                            Text(option.command)
                                .font(ModernFont.captionSmall)
                        }
                        .foregroundColor(ModernTheme.textTertiary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? accentColor.opacity(0.08) : ModernTheme.bgSubtle)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isSelected ? accentColor : ModernTheme.border,
                        lineWidth: isSelected ? 1.5 : 0.8
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .brightness(isPressed ? 0.05 : 0)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Quiz Choice Button

struct QuizChoiceButton: View {
    let prefix: String
    let text: String
    let accentColor: Color
    let isSelected: Bool
    let isCorrectAnswer: Bool
    let isAnswered: Bool
    let isDisabled: Bool
    let action: () -> Void

    private var borderColor: Color {
        if isAnswered && isCorrectAnswer { return ModernTheme.success }
        if isAnswered && isSelected { return ModernTheme.danger }
        if isSelected { return accentColor }
        return ModernTheme.border
    }

    private var fillColor: Color {
        if isAnswered && isCorrectAnswer { return ModernTheme.successSoft.opacity(0.55) }
        if isAnswered && isSelected { return ModernTheme.dangerSoft.opacity(0.55) }
        if isSelected { return accentColor.opacity(0.06) }
        return ModernTheme.bgSubtle
    }

    private var prefixColor: Color {
        if isAnswered && isCorrectAnswer { return ModernTheme.success }
        if isAnswered && isSelected { return ModernTheme.danger }
        if isSelected { return accentColor }
        return ModernTheme.textTertiary
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 10) {
                Text(prefix)
                    .font(ModernFont.labelMedium)
                    .foregroundColor(prefixColor)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(prefixColor.opacity(0.12)))

                Text(text)
                    .font(ModernFont.bodyMedium)
                    .foregroundColor(ModernTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .minimumScaleFactor(0.86)

                Spacer(minLength: 8)

                if isAnswered {
                    Image(systemName: isCorrectAnswer ? "checkmark.circle.fill" : (isSelected ? "xmark.circle.fill" : "circle"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isCorrectAnswer ? ModernTheme.success : (isSelected ? ModernTheme.danger : ModernTheme.textMuted))
                } else {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? accentColor : ModernTheme.textTertiary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(fillColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected || (isAnswered && isCorrectAnswer) ? 1.2 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled && !isAnswered ? 0.55 : 1)
    }
}

struct QuizExplanationCard: View {
    let isCorrect: Bool
    let explanation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill((isCorrect ? ModernTheme.success : ModernTheme.secondary).opacity(0.12))
                        .frame(width: 34, height: 34)
                    Image(systemName: isCorrect ? "checkmark.seal.fill" : "exclamationmark.circle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isCorrect ? ModernTheme.success : ModernTheme.secondary)
                }

                Text(isCorrect ? "正解です" : "解説")
                    .font(ModernFont.headlineSmall)
                    .foregroundColor(ModernTheme.textPrimary)

                Spacer()
            }

            Text(explanation)
                .font(ModernFont.bodySmall)
                .foregroundColor(ModernTheme.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCorrect ? ModernTheme.successSoft.opacity(0.08) : ModernTheme.secondarySoft.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCorrect ? ModernTheme.success.opacity(0.2) : ModernTheme.secondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 1)
    }
}
