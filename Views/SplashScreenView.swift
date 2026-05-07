import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var titleOffset: CGFloat = 12
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var pulse: Bool = false

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Logo mark
                ZStack {
                    Circle()
                        .fill(ModernTheme.heroGradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: ModernTheme.secondary.opacity(0.35), radius: 30, x: 0, y: 12)

                    Image(systemName: "terminal.fill")
                        .font(.system(size: 54, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .scaleEffect(pulse ? 1.04 : 1.0)
                .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulse)

                VStack(spacing: 10) {
                    Text("LinaTeX")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(ModernTheme.textPrimary)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)

                    Text("Linuxを楽しく学ぶ")
                        .font(ModernFont.bodyLarge)
                        .foregroundColor(ModernTheme.textSecondary)
                        .opacity(subtitleOpacity)
                }

                Spacer()

                // Loading indicator
                LoadingDots()
                    .opacity(subtitleOpacity)
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.5)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                subtitleOpacity = 1.0
            }
            pulse = true
        }
    }
}

struct LoadingDots: View {
    @State private var activeIndex: Int = 0

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(activeIndex == i ? ModernTheme.primary : ModernTheme.borderStrong)
                    .frame(width: 8, height: 8)
                    .scaleEffect(activeIndex == i ? 1.25 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: activeIndex)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
                activeIndex = (activeIndex + 1) % 3
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
