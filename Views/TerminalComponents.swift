import SwiftUI

// MARK: - Terminal Panel (Modern Light)

struct TerminalPanel: View {
    let input: String
    let output: String
    let state: LessonState
    let successMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Terminal header bar
            HStack(spacing: 8) {
                Circle().fill(Color(hex: 0xFF5F57)).frame(width: 10, height: 10)
                Circle().fill(Color(hex: 0xFEBC2E)).frame(width: 10, height: 10)
                Circle().fill(Color(hex: 0x28C840)).frame(width: 10, height: 10)
                Spacer()
                Text("terminal")
                    .font(ModernFont.codeSmall)
                    .foregroundColor(Color.white.opacity(0.5))
                Spacer()
                Color.clear.frame(width: 38, height: 1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: 0x0F172A))

            // Terminal body
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text("user@linatex")
                                .foregroundColor(Color(hex: 0x10B981))
                                .font(ModernFont.codeSmall)
                            Text(":")
                                .foregroundColor(Color.white.opacity(0.5))
                                .font(ModernFont.codeSmall)
                            Text("~")
                                .foregroundColor(Color(hex: 0x60A5FA))
                                .font(ModernFont.codeSmall)
                            Text("$")
                                .foregroundColor(Color.white.opacity(0.7))
                                .font(ModernFont.codeSmall)
                            Text(input)
                                .foregroundColor(.white)
                                .font(ModernFont.codeSmall)
                            if state == .waiting {
                                CursorView()
                            }
                            Spacer()
                        }
                        .id("input")

                        if !output.isEmpty {
                            Text(output)
                                .font(ModernFont.codeSmall)
                                .foregroundColor(Color.white.opacity(0.85))
                                .lineSpacing(2)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id("output")
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .onChange(of: output) { _ in
                        withAnimation { proxy.scrollTo("output", anchor: .bottom) }
                    }
                }
            }
            .frame(minHeight: 160)
            .background(Color(hex: 0x1E293B))
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: ModernTheme.shadowColorMedium, radius: 12, x: 0, y: 4)
    }
}

// MARK: - Cursor

struct CursorView: View {
    @State private var visible = true

    var body: some View {
        Rectangle()
            .fill(Color(hex: 0x10B981))
            .frame(width: 8, height: 14)
            .opacity(visible ? 0.9 : 0.2)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.55).repeatForever()) {
                    visible.toggle()
                }
            }
    }
}
