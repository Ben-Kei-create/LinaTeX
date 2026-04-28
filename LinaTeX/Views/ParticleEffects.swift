import SwiftUI

// MARK: - Celebration Particle Effect

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var opacity: Double = 1.0
}

struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    @State private var animationTimer: Timer?

    private let particleCount = 26
    private let duration: Double = 1.2

    var body: some View {
        Canvas { context, _ in
            for particle in particles {
                var context = context
                context.opacity = particle.opacity

                let frame = CGRect(
                    x: particle.position.x - 3,
                    y: particle.position.y - 3,
                    width: 6,
                    height: 6
                )

                context.fill(
                    Rectangle().path(in: frame),
                    with: .color(TerminalTheme.emeraldPrimary.opacity(0.82))
                )
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
            let speed = Double.random(in: 80...230)

            return Particle(
                position: CGPoint(x: 150, y: 150),
                velocity: CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
            )
        }
    }

    private func startAnimation() {
        var elapsed: Double = 0
        let timeStep: Double = 0.016

        animationTimer = Timer.scheduledTimer(withTimeInterval: timeStep, repeats: true) { _ in
            elapsed += timeStep
            let progress = elapsed / duration

            if progress >= 1 {
                animationTimer?.invalidate()
                return
            }

            withAnimation(.linear(duration: timeStep)) {
                for index in particles.indices {
                    let gravity: CGFloat = 430
                    particles[index].position.x += particles[index].velocity.dx * timeStep
                    particles[index].position.y += particles[index].velocity.dy * timeStep + gravity * timeStep * timeStep
                    particles[index].velocity.dy += gravity * timeStep
                    particles[index].opacity = 1 - progress
                }
            }
        }
    }
}

// MARK: - Success Overlay

struct SuccessOverlayView: View {
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.92
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            TerminalTheme.background.opacity(0.72)
                .ignoresSafeArea()

            ParticleEffectView()
                .frame(width: 300, height: 300)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 14) {
                Text("OK")
                    .shellFont(.largeTitle, weight: .bold)
                    .foregroundColor(TerminalTheme.emeraldPrimary)

                Text("学習を記録しました")
                    .shellFont(.caption, weight: .bold)
                    .foregroundColor(TerminalTheme.textPrimary)

                ShellProgressBar(value: 1, height: 8)
            }
            .padding(24)
            .frame(width: 260, alignment: .leading)
            .background(TerminalTheme.bgSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: TerminalTheme.cardRadius, style: .continuous)
                    .stroke(TerminalTheme.emeraldPrimary.opacity(0.24), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: TerminalTheme.cardRadius, style: .continuous))
            .shadow(color: TerminalTheme.cardShadow, radius: 18, x: 0, y: 10)
            .scaleEffect(scale)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.78)) {
                scale = 1
                opacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
                withAnimation(.easeOut(duration: 0.24)) {
                    opacity = 0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                    onDismiss()
                }
            }
        }
    }
}

#Preview {
    SuccessOverlayView {}
}
