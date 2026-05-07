import XCTest
@testable import LinaTeX

class CurriculumDataTests: XCTestCase {

    // MARK: - Curriculum Structure Tests

    func testComprehensiveAllCoursesIsNotEmpty() {
        XCTAssertFalse(comprehensiveAllCourses.isEmpty)
    }

    func testCourseCountIsThree() {
        XCTAssertEqual(comprehensiveAllCourses.count, 3)
    }

    func testCourseLevelsAreDistinct() {
        let levels = comprehensiveAllCourses.map { $0.level }
        XCTAssertEqual(levels.count, 3)
        XCTAssertTrue(levels.contains(.basics))
        XCTAssertTrue(levels.contains(.standard))
        XCTAssertTrue(levels.contains(.advanced))
    }

    // MARK: - Basics Course Tests

    func testBasicsCourseLessons() {
        let basicsCourse = comprehensiveAllCourses.first(where: { $0.level == .basics })!
        XCTAssertGreater(basicsCourse.chapters.count, 0)
        XCTAssertGreater(basicsCourse.totalLessons, 0)
    }

    // MARK: - Standard Course Tests

    func testStandardCourseLessons() {
        let standardCourse = comprehensiveAllCourses.first(where: { $0.level == .standard })!
        XCTAssertGreater(standardCourse.chapters.count, 0)
        XCTAssertGreater(standardCourse.totalLessons, 0)
    }

    // MARK: - Advanced Course Tests

    func testAdvancedCourseLessons() {
        let advancedCourse = comprehensiveAllCourses.first(where: { $0.level == .advanced })!
        XCTAssertGreater(advancedCourse.chapters.count, 0)
        XCTAssertGreater(advancedCourse.totalLessons, 0)
    }

    // MARK: - Lesson Content Tests

    func testAllLessonsHaveContent() {
        for course in comprehensiveAllCourses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    XCTAssertNotNil(lesson.content)
                }
            }
        }
    }

    func testLessonContentTypes() {
        var hasConceptLessons = false
        var hasQuestLessons = false
        var hasScenarioLessons = false
        var hasQuizLessons = false

        for course in comprehensiveAllCourses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    switch lesson.content {
                    case .concept:
                        hasConceptLessons = true
                    case .quest:
                        hasQuestLessons = true
                    case .scenario:
                        hasScenarioLessons = true
                    case .quiz:
                        hasQuizLessons = true
                    }
                }
            }
        }

        XCTAssertTrue(hasConceptLessons)
        XCTAssertTrue(hasQuestLessons)
        XCTAssertTrue(hasScenarioLessons)
        XCTAssertTrue(hasQuizLessons)
    }

    // MARK: - Lesson Properties Tests

    func testAllLessonsHaveEmojis() {
        for course in comprehensiveAllCourses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    XCTAssertFalse(lesson.emoji.isEmpty)
                }
            }
        }
    }

    func testAllLessonsHaveTitles() {
        for course in comprehensiveAllCourses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    XCTAssertFalse(lesson.title.isEmpty)
                }
            }
        }
    }

    func testAllLessonsHaveValidDuration() {
        for course in comprehensiveAllCourses {
            for chapter in course.chapters {
                for lesson in chapter.lessons {
                    XCTAssertGreater(lesson.estimatedMinutes, 0)
                }
            }
        }
    }
}
