import SwiftUI

// MARK: - Lesson Tab

enum LessonTab {
    case learning
    case problem
}

// MARK: - Lesson Flow Indicator

struct LessonFlowIndicator: View {
    let currentTab: LessonTab
    let isCompleted: Bool
    let color: Color

    var body: some View {
        HStack(spacing: 0) {
            FlowStep(
                icon: "book.fill",
                label: "学習",
                isActive: currentTab == .learning,
                isDone: currentTab == .problem || isCompleted,
                color: color
            )

            FlowConnector(isActive: currentTab == .problem || isCompleted, color: color)

            FlowStep(
                icon: "target",
                label: "問題",
                isActive: currentTab == .problem,
                isDone: isCompleted,
                color: color
            )

            FlowConnector(isActive: isCompleted, color: color)

            FlowStep(
                icon: "checkmark",
                label: "完了",
                isActive: false,
                isDone: isCompleted,
                color: ModernTheme.success
            )
        }
    }
}

// MARK: - Flow Step

struct FlowStep: View {
    let icon: String
    let label: String
    let isActive: Bool
    let isDone: Bool
    let color: Color

    var fillColor: Color {
        if isDone { return color }
        if isActive { return color }
        return ModernTheme.bgSubtle
    }

    var iconColor: Color {
        if isDone || isActive { return .white }
        return ModernTheme.textTertiary
    }

    var labelColor: Color {
        if isActive { return color }
        if isDone { return ModernTheme.textPrimary }
        return ModernTheme.textTertiary
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 36, height: 36)
                if isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(iconColor)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }
            .shadow(
                color: (isActive || isDone) ? color.opacity(0.3) : Color.clear,
                radius: 6, x: 0, y: 2
            )

            Text(label)
                .font(ModernFont.labelSmall)
                .foregroundColor(labelColor)
                .fontWeight(isActive ? .semibold : .regular)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Flow Connector

struct FlowConnector: View {
    let isActive: Bool
    let color: Color

    var body: some View {
        Rectangle()
            .fill(isActive ? color : ModernTheme.borderStrong)
            .frame(height: 2)
            .padding(.bottom, 22)
            .padding(.horizontal, -4)
    }
}

// MARK: - Tab Selector Button

struct TabSelectorButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(label)
                    .font(ModernFont.bodyEmphasizedSmall)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color : ModernTheme.bgSubtle)
            )
            .foregroundColor(isSelected ? .white : ModernTheme.textSecondary)
            .shadow(
                color: isSelected ? color.opacity(0.3) : Color.clear,
                radius: 8, x: 0, y: 3
            )
        }
    }
}
