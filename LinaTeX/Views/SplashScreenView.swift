import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var ringScale: CGFloat = 0.8
    @State private var ringOpacity: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: 0x5BB8D4), Color(hex: 0x55BA87)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Subtle background circles
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 320, height: 320)
                .offset(x: -80, y: -160)
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 240, height: 240)
                .offset(x: 100, y: 200)

            VStack(spacing: 0) {
                Spacer()

                // Icon card
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                        .frame(width: 148, height: 148)
                        .scaleEffect(ringScale)
                        .opacity(ringOpacity)

                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                        .frame(width: 112, height: 112)
                        .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 10)

                    Text(">_")
                        .font(.system(size: 38, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: 0x3BAAC9))
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                Spacer().frame(height: 32)

                VStack(spacing: 8) {
                    Text("LinaTeX")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Linux コマンドを学ぼう")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.82))
                }
                .opacity(textOpacity)

                Spacer()

                VStack(spacing: 8) {
                    ProgressView()
                        .tint(Color.white.opacity(0.8))
                        .scaleEffect(0.9)
                    Text("読み込み中...")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                .opacity(textOpacity)
                .padding(.bottom, 56)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.68)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                ringScale = 1.15
                ringOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.45).delay(0.35)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
