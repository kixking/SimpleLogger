import XCTest
@testable import SimpleLogger

final class SimpleLoggerTests: XCTestCase {

    // MARK: - Formatting

    func testFormatIncludesFileNameLineAndFunction() {
        let formatted = Log.format("Hello", file: "SimpleLogger/Log.swift", function: "doSomething()", line: 42)
        XCTAssertEqual(formatted, "[Log.swift:42 doSomething()] Hello")
    }

    func testFileNameExtractsLastPathComponent() {
        XCTAssertEqual(Log.fileName("SimpleLogger/Log.swift"), "Log.swift")
        XCTAssertEqual(Log.fileName("Module/Sub/Deep/File.swift"), "File.swift")
        XCTAssertEqual(Log.fileName("Log.swift"), "Log.swift")
        XCTAssertEqual(Log.fileName(""), "")
    }

    // MARK: - Configuration

    func testConfiguration() {
        // Verify that configure and re-configure (cache reset) don't crash.
        Log.configure(subsystem: "com.example.test", category: "Test")
        Log.configure(subsystem: "com.example.another", category: "Another")
    }

    // MARK: - Static API

    func testStaticLogExecution() {
        // os.Logger output cannot be captured in unit tests,
        // so exercise every code path to ensure no crashes occur.
        Log.info("Info message")
        Log.warning("Warning message")
        Log.error("Error message")
        Log.debug("Debug message")
        Log.fault("Fault message")
        Log.trace()

        struct TestError: Error, LocalizedError {
            var errorDescription: String? { "Test Error Description" }
        }
        Log.error(TestError())
    }

    // MARK: - Instance API

    func testCategoryInstanceLogExecution() {
        let log = Log(category: "Network")
        log.info("Info message")
        log.warning("Warning message")
        log.error("Error message")
        log.debug("Debug message")
        log.fault("Fault message")
        log.trace()

        struct TestError: Error {}
        log.error(TestError())

        let custom = Log(subsystem: "com.example.custom", category: "Custom")
        custom.info("Custom subsystem message")
    }

    // MARK: - Concurrency

    @MainActor
    func testConcurrentLogging() {
        let expectation = self.expectation(description: "Concurrent logging completed")

        // 複数のスレッドから同時にアクセスし、デッドロックやデータレースが発生しないか検証
        DispatchQueue.global().async {
            DispatchQueue.concurrentPerform(iterations: 100) { index in
                if index % 10 == 0 {
                    Log.configure(subsystem: "com.example.concurrent-\(index)", category: "Test-\(index)")
                }
                Log.info("Concurrent log message \(index)")

                let customLogger = Log(category: "Concurrent-Category-\(index)")
                customLogger.info("Custom concurrent log message \(index)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0)
    }

    func testTaskGroupConcurrentLogging() async {
        // Swift Concurrency (Structured Concurrency) の TaskGroup を用い、
        // 多数の並行 Task から同時にアクセスした際のスレッド安全性とデータレース不在を検証
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<100 {
                group.addTask {
                    if index % 10 == 0 {
                        Log.configure(subsystem: "com.example.taskgroup-\(index)", category: "Test-\(index)")
                    }
                    Log.info("TaskGroup log message \(index)")

                    let customLogger = Log(category: "TaskGroup-Category-\(index)")
                    customLogger.info("Custom taskgroup log message \(index)")
                }
            }
        }
    }
}

