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
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(fillColor)
                    .frame(width: 30, height: 30)
                if isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(iconColor)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }
            .shadow(
                color: (isActive || isDone) ? color.opacity(0.2) : Color.clear,
                radius: 4, x: 0, y: 1
            )

            Text(label)
                .font(ModernFont.captionSmall)
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
            .fill(isActive ? color : ModernTheme.border)
            .frame(height: 1.5)
            .padding(.bottom, 18)
            .padding(.horizontal, -2)
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
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(label)
                    .font(ModernFont.labelMedium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? color : ModernTheme.bgSubtle)
            )
            .foregroundColor(isSelected ? .white : ModernTheme.textSecondary)
            .shadow(
                color: isSelected ? color.opacity(0.2) : Color.clear,
                radius: 5, x: 0, y: 1
            )
        }
    }
}
