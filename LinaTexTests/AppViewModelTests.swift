import XCTest
@testable import LinaTeX

class AppViewModelTests: XCTestCase {
    var sut: AppViewModel!

    override func setUp() {
        super.setUp()
        sut = AppViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Navigation Tests

    func testNavigationPathStartsEmpty() {
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }

    func testNavigateToCourse() {
        let testCourse = sut.courses.first!
        sut.navigateToCourse(testCourse)
        XCTAssertEqual(sut.navigationPath.count, 1)
    }

    func testGoBackRemovesLastNavigation() {
        let testCourse = sut.courses.first!
        sut.navigateToCourse(testCourse)
        XCTAssertEqual(sut.navigationPath.count, 1)
        sut.goBack()
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }

    // MARK: - Progress Tracking Tests

    func testCompletedLessonsStartEmpty() {
        XCTAssertTrue(sut.completedLessons.isEmpty)
    }

    func testTotalXPStartsAtZero() {
        XCTAssertEqual(sut.totalXP, 0)
    }

    func testSuccessRateCalculation() {
        sut.totalLessonAttempts = 10
        sut.correctAnswers = 7
        let expected = 70.0
        XCTAssertEqual(sut.successRate, expected)
    }

    func testSuccessRateWithZeroAttempts() {
        XCTAssertEqual(sut.successRate, 0)
    }

    // MARK: - Course Progress Tests

    func testProgressInCourseWithoutCompletion() {
        let course = sut.courses.first!
        let progress = sut.progressInCourse(course)
        XCTAssertEqual(progress, 0)
    }

    func testTotalProgressCalculation() {
        let initialProgress = sut.totalProgress()
        XCTAssertEqual(initialProgress, 0)
    }
}
