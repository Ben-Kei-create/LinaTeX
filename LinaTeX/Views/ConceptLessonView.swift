import SwiftUI

// MARK: - Concept Lesson View

struct ConceptLessonView: View {
    let concept: ConceptLesson
    var course: Course? = nil

    var accentColor: Color {
        course?.level.modernColor ?? ModernTheme.primary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(concept.headline)
                .font(ModernFont.headlineLarge)
                .foregroundColor(ModernTheme.textPrimary)
                .padding(.horizontal, 20)

            VStack(spacing: 14) {
                ForEach(concept.sections) { section in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(section.heading)
                            .font(ModernFont.headlineSmall)
                            .foregroundColor(ModernTheme.textPrimary)

                        Text(section.body)
                            .font(ModernFont.bodyMedium)
                            .foregroundColor(ModernTheme.textSecondary)
                            .lineSpacing(6)

                        if let code = section.codeSample {
                            CodeBlock(text: code, accent: accentColor)
                        }

                        if let tip = section.tip {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(ModernTheme.warning)
                                Text(tip)
                                    .font(ModernFont.bodySmall)
                                    .foregroundColor(ModernTheme.textPrimary)
                                    .lineSpacing(4)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ModernTheme.warningSoft.opacity(0.5))
                            )
                        }
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ModernTheme.bgCard)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ModernTheme.border, lineWidth: 1)
                    )
                    .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Code Block

struct CodeBlock: View {
    let text: String
    var accent: Color = ModernTheme.primary

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("$")
                .font(ModernFont.codeMedium)
                .foregroundColor(accent)
            Text(text)
                .font(ModernFont.codeMedium)
                .foregroundColor(ModernTheme.codeText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ModernTheme.codeBg)
        )
    }
}
