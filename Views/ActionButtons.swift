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

// MARK: - Hint Block

struct HintBlock: View {
    let text: String
    let isShown: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: toggle) {
                HStack(spacing: 6) {
                    Image(systemName: isShown ? "lightbulb.fill" : "lightbulb")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ModernTheme.warning)
                    Text(isShown ? "隠す" : "ヒント")
                        .font(ModernFont.labelMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                    Spacer()
                    Image(systemName: isShown ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(ModernTheme.textTertiary)
                }
                .padding(10)
            }

            if isShown {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(ModernTheme.warning)
                        .font(.system(size: 12))
                    Text(text)
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineSpacing(2)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Rectangle().fill(ModernTheme.warningSoft.opacity(0.3))
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ModernTheme.warning.opacity(0.2), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Command Button (Modern Light)

struct CommandButton: View {
    let option: CommandOption
    let accentColor: Color
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

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

                Text(option.label)
                    .font(ModernFont.codeSmall)
                    .foregroundColor(ModernTheme.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? accentColor.opacity(0.06) : ModernTheme.bgSubtle)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isSelected ? accentColor : ModernTheme.border,
                        lineWidth: isSelected ? 1.2 : 0.5
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}
