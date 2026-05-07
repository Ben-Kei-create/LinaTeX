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
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: - Hero Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("LinaTeX")
                                    .font(ModernFont.displayLarge)
                                    .foregroundColor(ModernTheme.textPrimary)

                                Text("Linuxを楽しく学ぼう")
                                    .font(ModernFont.bodyMedium)
                                    .foregroundColor(ModernTheme.textSecondary)
                            }
                            Spacer()
                            NavigationLink(destination: StatisticsView(vm: vm)) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(ModernTheme.primary)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle().fill(ModernTheme.bgCard)
                                    )
                                    .shadow(color: ModernTheme.shadowColor, radius: 6, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // MARK: - Progress Card (Hero Style)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("学習進捗")
                                    .font(ModernFont.labelMedium)
                                    .foregroundColor(.white.opacity(0.85))
                                Text("\(totalCompleted) / \(totalLessons) レッスン")
                                    .font(ModernFont.headlineMedium)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Text("\(Int(vm.totalProgress() * 100))%")
                                .font(ModernFont.displayMedium)
                                .foregroundColor(.white)
                        }

                        ProgressBarView(
                            progress: vm.totalProgress(),
                            tint: .white,
                            track: Color.white.opacity(0.25)
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ModernTheme.heroGradient)
                    )
                    .shadow(color: ModernTheme.secondary.opacity(0.25), radius: 20, x: 0, y: 8)
                    .padding(.horizontal, 20)

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
                    .padding(.horizontal, 20)

                    // MARK: - Courses Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("コース一覧")
                                .font(ModernFont.headlineLarge)
                                .foregroundColor(ModernTheme.textPrimary)
                            Spacer()
                            Text("\(vm.courses.count)コース")
                                .font(ModernFont.labelMedium)
                                .foregroundColor(ModernTheme.textTertiary)
                        }
                        .padding(.horizontal, 20)

                        VStack(spacing: 14) {
                            ForEach(vm.courses) { course in
                                CourseCard(course: course, vm: vm)
                                    .onTapGesture {
                                        vm.navigateToCourse(course)
                                    }
                            }
                        }
                    }

                    Spacer(minLength: 40)
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
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                // Level emoji badge
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(course.level.modernGradient)
                        .frame(width: 56, height: 56)
                    Text(course.emoji)
                        .font(.system(size: 30))
                }
                .shadow(color: course.level.modernColor.opacity(0.3), radius: 8, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text(course.level.japanese)
                        .modernPill(color: course.level.modernColor)

                    Text(course.title)
                        .font(ModernFont.headlineMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                        .lineLimit(2)

                    Text(course.subtitle)
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)
            }

            Text(course.description)
                .font(ModernFont.bodySmall)
                .foregroundColor(ModernTheme.textSecondary)
                .lineSpacing(3)
                .lineLimit(3)

            // Stats row
            HStack(spacing: 16) {
                Label {
                    Text("\(course.totalLessons)レッスン")
                        .font(ModernFont.labelMedium)
                } icon: {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 12))
                }
                .foregroundColor(ModernTheme.textSecondary)

                Label {
                    Text("\(course.estimatedMinutes)分")
                        .font(ModernFont.labelMedium)
                } icon: {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                }
                .foregroundColor(ModernTheme.textSecondary)

                Spacer()

                if progress > 0 {
                    Text("\(Int(progress * 100))%")
                        .font(ModernFont.labelLarge)
                        .foregroundColor(course.level.modernColor)
                }
            }

            // Progress bar
            VStack(alignment: .leading, spacing: 6) {
                ProgressBarView(
                    progress: progress,
                    tint: course.level.modernColor,
                    track: ModernTheme.bgSubtle
                )

                if progress > 0 {
                    Text("\(completedLessons) / \(course.totalLessons) 完了")
                        .font(ModernFont.captionSmall)
                        .foregroundColor(ModernTheme.textTertiary)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(ModernTheme.bgCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(ModernTheme.border, lineWidth: 1)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
        .padding(.horizontal, 20)
    }
}
