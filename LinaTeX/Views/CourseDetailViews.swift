import SwiftUI

// MARK: - Course Detail View

struct CourseDetailView: View {
    let course: Course
    @ObservedObject var vm: AppViewModel

    var progress: Double { vm.progressInCourse(course) }

    var body: some View {
        ZStack {
            ModernTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { vm.goBack() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("戻る")
                                .font(ModernFont.bodyEmphasizedSmall)
                        }
                        .foregroundColor(course.level.modernColor)
                    }
                    Spacer()
                    Text(course.level.japanese)
                        .modernPill(color: course.level.modernColor)
                    Spacer()
                    Color.clear.frame(width: 56, height: 1)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(ModernTheme.bgCard.opacity(0.7))
                .overlay(
                    Rectangle()
                        .fill(ModernTheme.border)
                        .frame(height: 1),
                    alignment: .bottom
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Course Hero
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(course.level.modernGradient)
                                        .frame(width: 64, height: 64)
                                    Text(course.emoji)
                                        .font(.system(size: 34))
                                }
                                .shadow(color: course.level.modernColor.opacity(0.3), radius: 10, x: 0, y: 4)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(course.title)
                                        .font(ModernFont.headlineLarge)
                                        .foregroundColor(ModernTheme.textPrimary)
                                    Text(course.subtitle)
                                        .font(ModernFont.bodySmall)
                                        .foregroundColor(ModernTheme.textSecondary)
                                }
                            }

                            Text(course.description)
                                .font(ModernFont.bodyMedium)
                                .foregroundColor(ModernTheme.textSecondary)
                                .lineSpacing(4)

                            // Stats
                            HStack(spacing: 20) {
                                StatBadge(icon: "book.closed.fill", text: "\(course.totalLessons) レッスン", color: course.level.modernColor)
                                StatBadge(icon: "clock.fill", text: "\(course.estimatedMinutes)分", color: course.level.modernColor)
                                Spacer()
                            }

                            // Progress
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("進捗")
                                        .font(ModernFont.labelMedium)
                                        .foregroundColor(ModernTheme.textSecondary)
                                    Spacer()
                                    Text("\(Int(progress * 100))%")
                                        .font(ModernFont.labelLarge)
                                        .foregroundColor(course.level.modernColor)
                                }
                                ProgressBarView(
                                    progress: progress,
                                    tint: course.level.modernColor,
                                    track: ModernTheme.bgSubtle
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(ModernTheme.bgCard)
                        )
                        .shadow(color: ModernTheme.shadowColor, radius: 10, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                        // Chapters
                        ForEach(course.chapters) { chapter in
                            ChapterSection(chapter: chapter, course: course, vm: vm)
                                .padding(.horizontal, 20)
                        }

                        Spacer(minLength: 24)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Stat Badge

struct StatBadge: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(ModernFont.labelMedium)
        }
        .foregroundColor(color)
    }
}

// MARK: - Chapter Section

struct ChapterSection: View {
    let chapter: Chapter
    let course: Course
    @ObservedObject var vm: AppViewModel

    var completedCount: Int {
        chapter.lessons.filter { vm.isLessonCompleted($0) }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                // Chapter number badge
                ZStack {
                    Circle()
                        .fill(course.level.modernSoft)
                        .frame(width: 38, height: 38)
                    Text("\(chapter.number)")
                        .font(ModernFont.headlineMedium)
                        .foregroundColor(course.level.modernColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(chapter.title)
                        .font(ModernFont.headlineSmall)
                        .foregroundColor(ModernTheme.textPrimary)
                    Text(chapter.summary)
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
                if completedCount == chapter.lessons.count && chapter.lessons.count > 0 {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(ModernTheme.success)
                        .font(.system(size: 22))
                } else {
                    Text("\(completedCount)/\(chapter.lessons.count)")
                        .font(ModernFont.labelMedium)
                        .foregroundColor(ModernTheme.textTertiary)
                }
            }

            LazyVStack(spacing: 8) {
                ForEach(chapter.lessons) { lesson in
                    LessonRow(lesson: lesson, course: course, vm: vm)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ModernTheme.bgCard)
        )
        .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
    }
}

// MARK: - Lesson Row

struct LessonRow: View {
    let lesson: Lesson
    let course: Course
    @ObservedObject var vm: AppViewModel

    var isCompleted: Bool { vm.isLessonCompleted(lesson) }

    var body: some View {
        Button(action: {
            if isCompleted {
                vm.isReviewMode = true
            }
            vm.navigateToLesson(lesson, in: course)
        }) {
            HStack(spacing: 12) {
                // Lesson icon with completion indicator
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isCompleted ? ModernTheme.successSoft : course.level.modernSoft)
                        .frame(width: 48, height: 48)

                    Text(lesson.emoji)
                        .font(.system(size: 22))
                        .opacity(isCompleted ? 0.3 : 1)

                    if isCompleted {
                        ZStack {
                            Circle()
                                .fill(ModernTheme.success)
                                .frame(width: 22, height: 22)
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .offset(x: 4, y: 4)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(lesson.title)
                            .font(ModernFont.bodyEmphasizedSmall)
                            .foregroundColor(isCompleted ? ModernTheme.textTertiary : ModernTheme.textPrimary)
                            .multilineTextAlignment(.leading)

                        if isCompleted {
                            Text("完了")
                                .font(ModernFont.captionSmall)
                                .foregroundColor(ModernTheme.success)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(ModernTheme.successSoft)
                                .cornerRadius(4)
                        }
                    }

                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: lesson.content.typeIcon)
                                .font(.system(size: 10, weight: .semibold))
                            Text(lesson.content.typeLabel)
                                .font(ModernFont.labelSmall)
                        }
                        .foregroundColor(course.level.modernColor)

                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text("\(lesson.estimatedMinutes)分")
                                .font(ModernFont.labelSmall)
                        }
                        .foregroundColor(ModernTheme.textTertiary)

                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= lesson.difficulty ? "star.fill" : "star")
                                    .font(.system(size: 8))
                                    .foregroundColor(ModernTheme.warning)
                            }
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ModernTheme.textTertiary)
                    .opacity(isCompleted ? 0.5 : 1)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCompleted ? ModernTheme.successSoft.opacity(0.3) : ModernTheme.bgSubtle.opacity(0.6))
            )
            .opacity(isCompleted ? 0.85 : 1)
        }
        .buttonStyle(.plain)
    }
}
