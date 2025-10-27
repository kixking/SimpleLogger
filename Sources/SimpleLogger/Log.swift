// Log.swift
// MIT License

import Foundation
import os

public final class Log {

    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "General")

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
        logger.info("\(formatMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    public static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.warning("\(formatMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    public static func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        logger.error("\(formatMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    public static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        logger.debug("\(formatMessage(message, file: file, function: function, line: line), privacy: .public)")
        #endif
    }
}
