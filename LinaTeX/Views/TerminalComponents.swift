import SwiftUI

// MARK: - Terminal Panel (Modern Light)

struct TerminalPanel: View {
    let input: String
    let output: String
    let state: LessonState
    var minHeight: CGFloat = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Terminal header bar - compact
            HStack(spacing: 6) {
                Circle().fill(Color(hex: 0xFF5F57)).frame(width: 8, height: 8)
                Circle().fill(Color(hex: 0xFEBC2E)).frame(width: 8, height: 8)
                Circle().fill(Color(hex: 0x28C840)).frame(width: 8, height: 8)
                Spacer()
                Text("terminal")
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
                    .foregroundColor(Color.white.opacity(0.4))
                Spacer()
                Color.clear.frame(width: 30, height: 1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color(hex: 0x0F172A))

            // Terminal body - compact
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("user")
                                .foregroundColor(Color(hex: 0x10B981))
                                .font(.system(size: 11, weight: .regular, design: .monospaced))
                            Text("$ ")
                                .foregroundColor(Color.white.opacity(0.6))
                                .font(.system(size: 11, weight: .regular, design: .monospaced))
                            Text(input)
                                .foregroundColor(.white)
                                .font(.system(size: 11, weight: .regular, design: .monospaced))
                            if state == .waiting {
                                CursorView()
                            }
                            Spacer()
                        }
                        .id("input")

                        if !output.isEmpty {
                            Text(output)
                                .font(.system(size: 11, weight: .regular, design: .monospaced))
                                .foregroundColor(Color.white.opacity(0.8))
                                .lineSpacing(1)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id("output")
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .onChange(of: output) { _, _ in
                        withAnimation { proxy.scrollTo("output", anchor: .bottom) }
                    }
                }
            }
            .frame(minHeight: minHeight)
            .background(Color(hex: 0x1E293B))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: ModernTheme.shadowColorMedium, radius: 8, x: 0, y: 2)
    }
}

// MARK: - Cursor

struct CursorView: View {
    @State private var visible = true

    var body: some View {
        Rectangle()
            .fill(Color(hex: 0x10B981))
            .frame(width: 6, height: 11)
            .opacity(visible ? 0.9 : 0.2)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.55).repeatForever()) {
                    visible.toggle()
                }
            }
    }
}
