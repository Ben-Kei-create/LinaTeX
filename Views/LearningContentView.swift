import SwiftUI

struct LearningContentView: View {
    let lesson: Lesson
    let learning: LearningMaterial

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(learning.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(learning.description)
                        .font(.caption)
                        .foregroundColor(Color(hex: 0xB0B0B0))
                }
                .padding(.bottom, 8)

                Divider()
                    .background(Color(hex: 0x00FF41, alpha: 0.3))

                // Content sections
                ForEach(learning.sections.indices, id: \.self) { index in
                    SectionView(section: learning.sections[index])
                }

                Spacer()
            }
            .padding(16)
        }
        .background(Color.black)
    }
}

struct SectionView: View {
    let section: LearningSection

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Heading with green accent
            HStack(spacing: 8) {
                Text("▶")
                    .font(.caption)
                    .foregroundColor(Color(hex: 0x00FF41))

                Text(section.heading)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: 0x00FF41))
            }

            // Body text
            Text(section.body)
                .font(.body)
                .lineHeight(1.6)
                .foregroundColor(.white)

            // Code example if present
            if let example = section.example {
                VStack(alignment: .leading, spacing: 4) {
                    Text("コード例:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: 0x00DD33))

                    Text(example)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(Color(hex: 0x00FF99))
                        .padding(10)
                        .background(Color(red: 0.03, green: 0.03, blue: 0.03))
                        .cornerRadius(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // Tip if present
            if let tip = section.tip {
                HStack(alignment: .top, spacing: 10) {
                    Text("💡")
                        .font(.caption)

                    Text(tip)
                        .font(.caption)
                        .foregroundColor(Color(hex: 0xFFAA00))
                }
                .padding(10)
                .background(Color(hex: 0xFFAA00, alpha: 0.1))
                .cornerRadius(6)
            }
        }
        .padding(12)
        .background(Color(red: 0.03, green: 0.03, blue: 0.03))
        .borderRadius(8)
    }
}

extension View {
    func borderRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color(hex: 0x00FF41, alpha: 0.2), lineWidth: 1)
            )
    }

    func lineHeight(_ lineHeight: CGFloat) -> some View {
        self.tracking(0)
    }
}

#Preview {
    LearningContentView(
        lesson: Lesson(
            title: "Test",
            emoji: "📚",
            estimatedMinutes: 10,
            content: .concept(ConceptLesson(
                headline: "test",
                sections: []
            ))
        ),
        learning: LearningMaterial(
            title: "Linux基本入門",
            description: "Linuxの基本的な概念を学びます",
            content: "Sample content",
            sections: [
                LearningSection(
                    heading: "Linuxとは",
                    body: "Linuxはオープンソースのオペレーティングシステムです。サーバーから組み込みシステムまで広く使用されています。",
                    example: "$ uname -a",
                    tip: "Linuxにはさまざまなディストリビューションがあります"
                )
            ]
        )
    )
}
