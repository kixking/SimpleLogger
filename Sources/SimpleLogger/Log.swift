// Log.swift
// MIT License

import Foundation
import os

public final class Log {

    private static var subsystem = Bundle.main.bundleIdentifier ?? "App"
    private static var category = "General"
    
    private static var logger: Logger = {
        return Logger(subsystem: subsystem, category: category)
    }()

    /// Configures the logger with a specific subsystem and category.
    /// - Parameters:
    ///   - subsystem: The subsystem identifier (usually the bundle ID).
    ///   - category: The category for the logs.
    public static func configure(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    private static func formatMessage(_ message: String, file: String, function: String, line: Int) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "[\(fileName):\(line) \(function)] \(message)"
    }

    public static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.info("\(formatMessage(message, file: file, function: function, line: line))")
    }

    public static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.warning("\(formatMessage(message, file: file, function: function, line: line))")
    }

    public static func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.error("\(formatMessage(message, file: file, function: function, line: line))")
    }
    
    public static func error(
        _ error: Error,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.error("\(formatMessage(error.localizedDescription, file: file, function: function, line: line))")
    }

    public static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        logger.debug("\(formatMessage(message, file: file, function: function, line: line))")
        #endif
    }
}
