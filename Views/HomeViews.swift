import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @ObservedObject var vm: AppViewModel
    @State private var selectedCourse: Course?

    var totalCompleted: Int { vm.completedLessons.count }
    var totalLessons: Int { vm.courses.reduce(0) { $0 + $1.totalLessons } }

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Hero Header
                    VStack(alignment: .leading, spacing: 4) {
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
                            NavigationLink(destination: StatisticsView(vm: vm)) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ModernTheme.primary)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle().fill(ModernTheme.bgCard)
                                    )
                                    .shadow(color: ModernTheme.shadowColor, radius: 4, x: 0, y: 1)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    // MARK: - Progress Card (Hero Style)
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
                            Text("\(Int(vm.totalProgress() * 100))%")
                                .font(ModernFont.displaySmall)
                                .foregroundColor(.white)
                        }

                        ProgressBarView(
                            progress: vm.totalProgress(),
                            tint: .white,
                            track: Color.white.opacity(0.25)
                        )
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ModernTheme.heroGradient)
                    )
                    .shadow(color: ModernTheme.secondary.opacity(0.2), radius: 12, x: 0, y: 4)
                    .padding(.horizontal, 16)

                    // MARK: - AI Recommendation
                    PersonalizedRecommendationView(vm: vm) { lesson in
                        if let course = vm.courses.first(where: { course in
                            course.chapters.contains { chapter in
                                chapter.lessons.contains { $0.id == lesson.id }
                            }
                        }) {
                            vm.navigateToLesson(lesson, in: course)
                        }
                    }
                    .padding(.horizontal, 16)

                    // MARK: - Courses Section
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

                        VStack(spacing: 10) {
                            ForEach(vm.courses) { course in
                                CourseCard(course: course, vm: vm)
                                    .onTapGesture {
                                        vm.navigateToCourse(course)
                                    }
                            }
                        }
                    }

                    Spacer(minLength: 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
                // Level emoji badge
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
            }

            // Stats row - compact
            HStack(spacing: 12) {
                Label {
                    Text("\(course.totalLessons)")
                        .font(ModernFont.labelSmall)
                } icon: {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 11))
                }
                .foregroundColor(ModernTheme.textTertiary)

                Label {
                    Text("\(course.estimatedMinutes)分")
                        .font(ModernFont.labelSmall)
                } icon: {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 11))
                }
                .foregroundColor(ModernTheme.textTertiary)

                Spacer()

                if progress > 0 {
                    Text("\(Int(progress * 100))%")
                        .font(ModernFont.labelMedium)
                        .foregroundColor(course.level.modernColor)
                }
            }

            // Progress bar
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
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ModernTheme.border, lineWidth: 0.5)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}
