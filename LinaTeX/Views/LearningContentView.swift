import SwiftUI

struct LearningContentView: View {
    let lesson: Lesson
    let learning: LearningMaterial

    var body: some View {
        ShellScreen {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ShellPanel {
                        VStack(alignment: .leading, spacing: 10) {
                            ShellSectionTitle(title: learning.title, subtitle: lesson.title)

                            Text(learning.description)
                                .shellFont(.caption)
                                .foregroundColor(TerminalTheme.textSecondary)
                                .lineSpacing(3)
                        }
                    }

                    ForEach(learning.sections.indices, id: \.self) { index in
                        SectionView(section: learning.sections[index])
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
    }
}

struct SectionView: View {
    let section: LearningSection

    var body: some View {
        ShellPanel(borderOpacity: 0.18) {
            VStack(alignment: .leading, spacing: 10) {
                ShellSectionTitle(title: section.heading, subtitle: nil)

                Text(section.body)
                    .shellFont(.body)
                    .foregroundColor(TerminalTheme.textSecondary)
                    .lineSpacing(4)

                if let example = section.example {
                    CodeBlock(code: example)
                }

                if let tip = section.tip {
                    Text("NOTE: \(tip)")
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.greenTertiary)
                        .lineSpacing(3)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                .fill(TerminalTheme.greenPrimary.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                .stroke(TerminalTheme.borderColor, lineWidth: 1)
                        )
                }
            }
        }
    }
}

#Preview {
    LearningContentView(
        lesson: Lesson(
            title: "Test",
            emoji: "",
            estimatedMinutes: 10,
            content: .concept(ConceptLesson(headline: "test", sections: []))
        ),
        learning: LearningMaterial(
            title: "Linux基本入門",
            description: "Linuxの基本的な概念を学びます",
            content: "Sample content",
            sections: [
                LearningSection(
                    heading: "Linuxとは",
                    body: "Linuxはオープンソースのオペレーティングシステムです。",
                    example: "$ uname -a",
                    tip: "Linuxにはさまざまなディストリビューションがあります"
                )
            ]
        )
    )
}
