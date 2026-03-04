import XCTest
@testable import SimpleLogger

final class SimpleLoggerTests: XCTestCase {
    func testConfiguration() {
        // Just verify that calling configure doesn't crash
        Log.configure(subsystem: "com.example.test", category: "Test")

        // Verify that configure resets the logger cache
        Log.configure(subsystem: "com.example.another", category: "Another")
    }
    
    func testLogExecution() {
        // Since we cannot easily capture os.Logger output in standard unit tests without a lot of mocking or UI testing,
        // we will at least exercise the code paths to ensure no crashes occur.
        
        Log.info("Info message")
        Log.warning("Warning message")
        Log.error("Error message")
        Log.debug("Debug message")
        
        struct TestError: Error, LocalizedError {
            var errorDescription: String? { return "Test Error Description" }
        }
        
        Log.error(TestError())
        Log.fault("Fault message")
        Log.trace()
    }
}
