# LinaTeX Tests

This directory contains unit tests for the LinaTeX iOS app.

## Test Structure

### AppViewModelTests.swift
Tests for the main application view model:
- Navigation path management
- Progress tracking (XP, streak, completion)
- Success rate calculation
- Course progress tracking

### CurriculumDataTests.swift
Tests for curriculum data integrity:
- Course structure validation (count, levels, lessons)
- Lesson content type variety
- Required properties (emoji, title, duration)
- Lesson availability across all courses

## Running Tests

### Via Xcode
1. Open the LinaTeX project in Xcode
2. Select Product → Test (or press Cmd+U)
3. Results appear in the Test Navigator

### Via Command Line
```bash
xcodebuild test -scheme LinaTeX
```

## Test Coverage Goals

Current coverage areas:
- ✅ Navigation state management
- ✅ Progress tracking calculations
- ✅ Curriculum data integrity

Future coverage areas:
- Learning path analyzer logic
- Command execution simulation
- Lesson state transitions
- Persistence layer

## Adding New Tests

1. Create a new test file with `Tests.swift` suffix
2. Extend `XCTestCase`
3. Follow naming convention: `test<Feature><Scenario><Result>`
4. Use descriptive assertion messages

Example:
```swift
func testNavigateToCoursePushesOntoStack() {
    let course = sut.courses.first!
    sut.navigateToCourse(course)
    XCTAssertEqual(sut.navigationPath.count, 1, 
                   "Navigation should push course onto stack")
}
```
