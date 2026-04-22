import SwiftUI

// MARK: - Celebration Particle Effect

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
}

struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    @State private var animationTimer: Timer?

    let particleCount: Int = 30
    let duration: Double = 1.5

    var body: some View {
        Canvas { context, size in
            for particle in particles {
                var ctx = context
                ctx.opacity = particle.opacity

                let frame = CGRect(
                    x: particle.position.x - 4,
                    y: particle.position.y - 4,
                    width: 8,
                    height: 8
                )

                let shape = Circle().path(in: frame)
                ctx.fill(shape, with: .color(.cyan.opacity(0.8)))
            }
        }
        .onAppear {
            generateParticles()
            startAnimation()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
    }

    private func generateParticles() {
        particles = (0..<particleCount).map { _ in
            let angle = Double.random(in: 0..<Double.pi * 2)
            let speed = Double.random(in: 100...300)

            return Particle(
                position: CGPoint(x: 150, y: 150),
                velocity: CGVector(
                    dx: cos(angle) * speed,
                    dy: sin(angle) * speed
                )
            )
        }
    }

    private func startAnimation() {
        var elapsed: Double = 0
        let timeStep: Double = 0.016

        animationTimer = Timer.scheduledTimer(withTimeInterval: timeStep, repeats: true) { _ in
            elapsed += timeStep
            let progress = elapsed / duration

            if progress >= 1.0 {
                animationTimer?.invalidate()
                return
            }

            withAnimation(.linear(duration: 0.016)) {
                for i in 0..<particles.count {
                    let gravity: CGFloat = 500

                    particles[i].position.x += particles[i].velocity.dx * timeStep
                    particles[i].position.y += particles[i].velocity.dy * timeStep + gravity * timeStep * timeStep

                    particles[i].velocity.dy += gravity * timeStep

                    particles[i].opacity = 1.0 - progress
                    particles[i].scale = 1.0 - (progress * 0.3)
                }
            }
        }
    }
}

// MARK: - Confetti Burst Animation

struct ConfettiBurstView: View {
    @State private var showConfetti = false
    @State private var scale: CGFloat = 0

    var body: some View {
        ZStack {
            // Particle effect
            if showConfetti {
                ParticleEffectView()
                    .frame(height: 300)
            }

            // Burst circle animation
            Circle()
                .fill(Color.cyan.opacity(0.3))
                .frame(width: 50, height: 50)
                .scaleEffect(scale)
                .opacity(showConfetti ? 0 : 1)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                scale = 3.0
                showConfetti = true
            }
        }
    }
}

// MARK: - Success Overlay

struct SuccessOverlayView: View {
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Dimming background
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Success icon with animation
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.cyan)
                    .scaleEffect(scale)

                VStack(spacing: 8) {
                    Text("成功！")
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("完璧だ！次へ進もう。")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(32)
            .background(Color(red: 0.11, green: 0.11, blue: 0.16))
            .cornerRadius(16)
            .shadow(radius: 20)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDismiss()
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.08, blue: 0.13)
            .ignoresSafeArea()

        VStack(spacing: 20) {
            ConfettiBurstView()

            Button("Show Success") {
                // Placeholder
            }
            .padding()
            .background(Color.cyan)
            .foregroundColor(.black)
            .cornerRadius(8)
        }
    }
}
