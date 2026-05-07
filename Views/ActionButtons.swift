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
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                Text(title)
                    .font(ModernFont.bodyEmphasized)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(fillColor)
            )
            .foregroundColor(foregroundColor)
            .shadow(color: shadowColor, radius: 10, x: 0, y: 4)
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
                HStack(spacing: 8) {
                    Image(systemName: isShown ? "lightbulb.fill" : "lightbulb")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ModernTheme.warning)
                    Text(isShown ? "ヒントを隠す" : "ヒントを見る")
                        .font(ModernFont.bodyEmphasizedSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                    Spacer()
                    Image(systemName: isShown ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ModernTheme.textTertiary)
                }
                .padding(14)
            }

            if isShown {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(ModernTheme.warning)
                        .font(.system(size: 14))
                    Text(text)
                        .font(ModernFont.bodyMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineSpacing(4)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Rectangle().fill(ModernTheme.warningSoft.opacity(0.4))
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ModernTheme.warning.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
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
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? accentColor : ModernTheme.borderStrong, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 12, height: 12)
                    }
                }

                Text(option.label)
                    .font(ModernFont.codeMedium)
                    .foregroundColor(ModernTheme.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? accentColor.opacity(0.08) : ModernTheme.bgCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? accentColor : ModernTheme.border,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.55 : 1.0)
    }
}
