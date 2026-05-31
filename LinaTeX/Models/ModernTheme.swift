import SwiftUI

// MARK: - Modern Light Theme (Tailwind-inspired)

struct ModernTheme {
    // MARK: - Background Colors
    static let bgPrimary = Color(hex: 0xF8FAFC)        // slate-50
    static let bgCard = Color.white
    static let bgSubtle = Color(hex: 0xF1F5F9)         // slate-100
    static let bgElevated = Color.white

    // MARK: - Text Colors
    static let textPrimary = Color(hex: 0x0F172A)      // slate-900
    static let textSecondary = Color(hex: 0x475569)    // slate-600
    static let textTertiary = Color(hex: 0x94A3B8)     // slate-400
    static let textMuted = Color(hex: 0xCBD5E1)        // slate-300

    // MARK: - Accent Colors
    static let primary = Color(hex: 0x3DAE7A)          // icon mint green (dark)
    static let primaryLight = Color(hex: 0x55BA87)     // icon mint green
    static let primarySoft = Color(hex: 0xD4EEE4)      // mint-100

    static let secondary = Color(hex: 0x3BAAC9)        // icon sky blue (dark)
    static let secondaryLight = Color(hex: 0x5BB8D4)   // icon sky blue
    static let secondarySoft = Color(hex: 0xD3EBF5)    // sky-100

    static let accent = Color(hex: 0x4498B8)           // deeper teal accent
    static let accentSoft = Color(hex: 0xD3EBF5)       // sky-100

    // MARK: - Status Colors
    static let success = Color(hex: 0x3DAE7A)          // icon mint green
    static let successSoft = Color(hex: 0xD4EEE4)      // mint-100
    static let warning = Color(hex: 0xF59E0B)          // amber-500
    static let warningSoft = Color(hex: 0xFEF3C7)      // amber-100
    static let danger = Color(hex: 0xEF4444)           // red-500
    static let dangerSoft = Color(hex: 0xFEE2E2)       // red-100

    // MARK: - Border Colors
    static let border = Color(hex: 0xE2E8F0)           // slate-200
    static let borderLight = Color(hex: 0xF1F5F9)      // slate-100
    static let borderStrong = Color(hex: 0xCBD5E1)     // slate-300

    // MARK: - Shadow
    static let shadowColor = Color(hex: 0x0F172A, alpha: 0.06)
    static let shadowColorMedium = Color(hex: 0x0F172A, alpha: 0.10)

    // MARK: - Background Gradients
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(hex: 0xEAF5FB),  // icon blue-50
            Color(hex: 0xE8F5EF)   // icon mint-50
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let primaryGradient = LinearGradient(
        colors: [
            Color(hex: 0x5BB8D4),  // icon sky blue
            Color(hex: 0x55BA87)   // icon mint green
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let secondaryGradient = LinearGradient(
        colors: [
            Color(hex: 0x5BB8D4),  // icon sky blue
            Color(hex: 0x3BAAC9)   // deeper sky blue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradient = LinearGradient(
        colors: [
            Color(hex: 0x5BB8D4),  // icon sky blue
            Color(hex: 0x55BA87)   // icon mint green
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [
            Color.white,
            Color(hex: 0xF8FAFC)   // slate-50
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Code/Terminal Background (used inside light theme for code samples)
    static let codeBg = Color(hex: 0x1E293B)           // slate-800
    static let codeBgSoft = Color(hex: 0xF1F5F9)       // slate-100
    static let codeText = Color(hex: 0x3DAE7A)          // icon mint green
}

// MARK: - Level Colors (Modern)

extension CourseLevel {
    var modernColor: Color {
        switch self {
        case .basics:   return ModernTheme.primary        // icon mint green
        case .standard: return ModernTheme.secondary     // icon sky blue
        case .advanced: return ModernTheme.accent        // deeper teal
        case .expert:   return ModernTheme.primary       // mint green
        }
    }

    var modernSoft: Color {
        switch self {
        case .basics:   return ModernTheme.primarySoft
        case .standard: return ModernTheme.secondarySoft
        case .advanced: return ModernTheme.accentSoft
        case .expert:   return ModernTheme.primarySoft
        }
    }

    var modernGradient: LinearGradient {
        switch self {
        case .basics:
            return LinearGradient(
                colors: [Color(hex: 0x55BA87), Color(hex: 0x3DAE7A)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .standard:
            return LinearGradient(
                colors: [Color(hex: 0x5BB8D4), Color(hex: 0x3BAAC9)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .advanced:
            return LinearGradient(
                colors: [Color(hex: 0x5BB8D4), Color(hex: 0x55BA87)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .expert:
            return LinearGradient(
                colors: [Color(hex: 0x3DAE7A), Color(hex: 0x3BAAC9)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }

    var modernEmoji: String {
        switch self {
        case .basics:   return "🌱"
        case .standard: return "🚀"
        case .advanced: return "⚡"
        case .expert:   return "🔮"
        }
    }
}

// MARK: - Typography

struct ModernFont {
    // Display - Large headlines
    static let displayLarge: Font = .system(size: 26, weight: .bold, design: .rounded)
    static let displayMedium: Font = .system(size: 22, weight: .bold, design: .rounded)
    static let displaySmall: Font = .system(size: 20, weight: .bold, design: .rounded)

    // Headlines
    static let headlineLarge: Font = .system(size: 18, weight: .semibold, design: .rounded)
    static let headlineMedium: Font = .system(size: 16, weight: .semibold, design: .rounded)
    static let headlineSmall: Font = .system(size: 15, weight: .semibold, design: .rounded)

    // Body
    static let bodyLarge: Font = .system(size: 15, weight: .regular, design: .rounded)
    static let bodyMedium: Font = .system(size: 14, weight: .regular, design: .rounded)
    static let bodySmall: Font = .system(size: 13, weight: .regular, design: .rounded)

    // Body Emphasized
    static let bodyEmphasized: Font = .system(size: 14, weight: .semibold, design: .rounded)
    static let bodyEmphasizedSmall: Font = .system(size: 13, weight: .semibold, design: .rounded)

    // Labels
    static let labelLarge: Font = .system(size: 13, weight: .semibold, design: .rounded)
    static let labelMedium: Font = .system(size: 12, weight: .medium, design: .rounded)
    static let labelSmall: Font = .system(size: 11, weight: .medium, design: .rounded)

    // Caption
    static let caption: Font = .system(size: 12, weight: .regular, design: .rounded)
    static let captionSmall: Font = .system(size: 10, weight: .regular, design: .rounded)

    // Mono for code/terminal (design stays monospaced)
    static let codeLarge: Font = .system(size: 13, weight: .regular, design: .monospaced)
    static let codeMedium: Font = .system(size: 12, weight: .regular, design: .monospaced)
    static let codeSmall: Font = .system(size: 11, weight: .regular, design: .monospaced)
}

// MARK: - View Modifiers

struct ModernCard: ViewModifier {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ModernTheme.bgCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(ModernTheme.border, lineWidth: 1)
            )
            .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
    }
}

struct ModernCardElevated: ViewModifier {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ModernTheme.bgCard)
            )
            .shadow(color: ModernTheme.shadowColorMedium, radius: 16, x: 0, y: 4)
    }
}

struct ModernPill: ViewModifier {
    var color: Color = ModernTheme.primary

    func body(content: Content) -> some View {
        content
            .font(ModernFont.labelSmall)
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color.opacity(0.12))
            )
    }
}

extension View {
    func modernCard(padding: CGFloat = 16, cornerRadius: CGFloat = 16) -> some View {
        modifier(ModernCard(padding: padding, cornerRadius: cornerRadius))
    }

    func modernCardElevated(padding: CGFloat = 16, cornerRadius: CGFloat = 16) -> some View {
        modifier(ModernCardElevated(padding: padding, cornerRadius: cornerRadius))
    }

    func modernPill(color: Color = ModernTheme.primary) -> some View {
        modifier(ModernPill(color: color))
    }
}
