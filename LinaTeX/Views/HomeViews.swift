import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @ObservedObject var vm: AppViewModel

    var totalCompleted: Int { vm.completedLessons.count }
    var totalLessons: Int { vm.courses.reduce(0) { $0 + $1.totalLessons } }

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // ── Title + Nav Icons ────────────────────────────────
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("LinaTeX")
                                    .font(ModernFont.displayLarge)
                                    .foregroundColor(ModernTheme.textPrimary)
                                Text("Linuxを楽しく学ぼう")
                                    .font(ModernFont.bodySmall)
                                    .foregroundColor(ModernTheme.textSecondary)
                            }
                            Spacer()
                            HStack(spacing: 10) {
                                // Command Dictionary
                                Button { vm.navigateToCommandDictionary() } label: {
                                    Image(systemName: "book.closed.fill")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(ModernTheme.primary)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(ModernTheme.bgCard))
                                        .shadow(color: ModernTheme.shadowColor, radius: 4, x: 0, y: 1)
                                }

                                // Achievements
                                NavigationLink(destination: AchievementsView(vm: vm)) {
                                    Image(systemName: "trophy.fill")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(ModernTheme.warning)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(ModernTheme.bgCard))
                                        .shadow(color: ModernTheme.shadowColor, radius: 4, x: 0, y: 1)
                                }

                                // Statistics
                                NavigationLink(destination: StatisticsView(vm: vm)) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(ModernTheme.primary)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(ModernTheme.bgCard))
                                        .shadow(color: ModernTheme.shadowColor, radius: 4, x: 0, y: 1)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                        // ── Overall Progress Card ────────────────────────────
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("学習進捗")
                                        .font(ModernFont.labelSmall)
                                        .foregroundColor(.white.opacity(0.85))
                                    Text("\(totalCompleted) / \(totalLessons) レッスン")
                                        .font(ModernFont.headlineSmall)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(Int(vm.totalProgress() * 100))%")
                                        .font(ModernFont.displaySmall)
                                        .foregroundColor(.white)
                                    if vm.streak > 0 {
                                        HStack(spacing: 4) {
                                            Image(systemName: "flame.fill")
                                                .font(.system(size: 14, weight: .semibold))
                                            Text("\(vm.streak)日連続")
                                                .font(ModernFont.labelMedium)
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(hex: 0xFF6B35).opacity(0.9))
                                        .cornerRadius(6)
                                    }
                                }
                            }
                            ProgressBarView(
                                progress: vm.totalProgress(),
                                tint: .white,
                                track: Color.white.opacity(0.25)
                            )
                        }
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 16).fill(ModernTheme.heroGradient))
                        .shadow(color: ModernTheme.secondary.opacity(0.2), radius: 12, x: 0, y: 4)
                        .padding(.horizontal, 16)

                        // ── Achievement Stats ──────────────────────────────
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                    Text("獲得ポイント")
                                        .font(ModernFont.labelSmall)
                                }
                                .foregroundColor(ModernTheme.warning)

                                Text("\(vm.totalXP) XP")
                                    .font(ModernFont.headlineSmall)
                                    .foregroundColor(ModernTheme.textPrimary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 6) {
                                HStack(spacing: 4) {
                                    Image(systemName: "target")
                                        .font(.system(size: 14))
                                    Text("正解率")
                                        .font(ModernFont.labelSmall)
                                }
                                .foregroundColor(ModernTheme.success)

                                if vm.totalLessonAttempts > 0 {
                                    Text("\(Int(Double(vm.correctAnswers) / Double(vm.totalLessonAttempts) * 100))%")
                                        .font(ModernFont.headlineSmall)
                                        .foregroundColor(ModernTheme.textPrimary)
                                } else {
                                    Text("---")
                                        .font(ModernFont.headlineSmall)
                                        .foregroundColor(ModernTheme.textTertiary)
                                }
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(ModernTheme.bgCard)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(ModernTheme.borderLight, lineWidth: 1)
                        )
                        .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 2)
                        .padding(.horizontal, 16)

                        // ── Continue Learning Card ───────────────────────────
                        if let next = vm.nextUncompletedLesson() {
                            ContinueLearningCard(lesson: next.lesson, course: next.course, vm: vm)
                                .padding(.horizontal, 16)
                        }

                        // ── Random Lesson Quick Start ──────────────────────────
                        HStack(spacing: 10) {
                            Button {
                                if let random = vm.randomUncompletedLesson() {
                                    vm.navigateToLesson(random.lesson, in: random.course)
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "dice.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("ランダムに開始")
                                            .font(ModernFont.labelMedium)
                                        Text("ナビを飛ばして即レッスン")
                                            .font(ModernFont.captionSmall)
                                            .foregroundColor(ModernTheme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                .foregroundColor(ModernTheme.primary)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ModernTheme.primarySoft.opacity(0.4))
                                )
                            }
                            .buttonStyle(.plain)

                            Button {
                                vm.navigateToCommandDictionary()
                            } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: "book.circle.fill")
                                        .font(.system(size: 20))
                                    Text("辞典")
                                        .font(ModernFont.labelSmall)
                                }
                                .foregroundColor(ModernTheme.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ModernTheme.secondarySoft.opacity(0.4))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 16)

                        // ── Courses ──────────────────────────────────────────
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("コース一覧")
                                    .font(ModernFont.headlineSmall)
                                    .foregroundColor(ModernTheme.textPrimary)
                                Spacer()
                                Text("\(vm.courses.count)コース")
                                    .font(ModernFont.labelSmall)
                                    .foregroundColor(ModernTheme.textTertiary)
                            }
                            .padding(.horizontal, 16)

                            LazyVStack(spacing: 10) {
                                ForEach(vm.courses) { course in
                                    CourseCard(course: course, vm: vm)
                                        .onTapGesture { vm.navigateToCourse(course) }
                                }
                            }
                        }

                        Spacer(minLength: 16)
                    }
                }

                // ── Fixed Bottom Ad Banner ───────────────────────────────────
                AdBannerView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Continue Learning Card

private struct ContinueLearningCard: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel

    var body: some View {
        Button { vm.navigateToLesson(lesson, in: course) } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(course.level.modernSoft)
                        .frame(width: 44, height: 44)
                    Text(lesson.emoji)
                        .font(.system(size: 22))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("続きから始める")
                        .font(ModernFont.captionSmall)
                        .foregroundColor(course.level.modernColor)
                    Text(lesson.title)
                        .font(ModernFont.bodyEmphasizedSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(1)
                    Text(course.title)
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textTertiary)
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(course.level.modernColor)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(ModernTheme.bgCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(course.level.modernColor.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: course.level.modernColor.opacity(0.08), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Progress Bar (Reusable)

struct ProgressBarView: View {
    let progress: Double
    var tint: Color = ModernTheme.primary
    var track: Color = ModernTheme.bgSubtle
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(track)
                Capsule()
                    .fill(tint)
                    .frame(width: max(0, geo.size.width * progress))
            }
        }
        .frame(height: height)
    }
}

// MARK: - Course Card

struct CourseCard: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var progress: Double { vm.progressInCourse(course) }
    var completedLessons: Int {
        course.chapters.reduce(0) { total, chapter in
            total + chapter.lessons.filter { vm.isLessonCompleted($0) }.count
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(course.level.modernGradient)
                        .frame(width: 48, height: 48)
                    Text(course.emoji)
                        .font(.system(size: 24))
                }
                .shadow(color: course.level.modernColor.opacity(0.2), radius: 6, x: 0, y: 2)

                VStack(alignment: .leading, spacing: 3) {
                    Text(course.level.japanese)
                        .modernPill(color: course.level.modernColor)
                    Text(course.title)
                        .font(ModernFont.headlineSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(2)
                    Text(course.subtitle)
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                // Completion checkmark
                if progress >= 1.0 {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(ModernTheme.success)
                        .font(.system(size: 20))
                }
            }

            HStack(spacing: 12) {
                Label {
                    Text("\(course.totalLessons)").font(ModernFont.labelSmall)
                } icon: {
                    Image(systemName: "book.closed.fill").font(.system(size: 11))
                }
                .foregroundColor(ModernTheme.textTertiary)

                Label {
                    Text("\(course.estimatedMinutes)分").font(ModernFont.labelSmall)
                } icon: {
                    Image(systemName: "clock.fill").font(.system(size: 11))
                }
                .foregroundColor(ModernTheme.textTertiary)

                Spacer()

                if progress > 0 {
                    Text("\(Int(progress * 100))%")
                        .font(ModernFont.labelMedium)
                        .foregroundColor(course.level.modernColor)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                ProgressBarView(
                    progress: progress,
                    tint: course.level.modernColor,
                    track: ModernTheme.bgSubtle,
                    height: 6
                )
                if progress > 0 {
                    Text("\(completedLessons) / \(course.totalLessons) 完了")
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textTertiary)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(ModernTheme.bgCard)
                .overlay(RoundedRectangle(cornerRadius: 14).fill(ModernTheme.accentGradient))
        )
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(ModernTheme.border, lineWidth: 0.5))
        .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}
