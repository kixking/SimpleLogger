// Log.swift
// MIT License

import Foundation
import os

/// A lightweight wrapper around `os.Logger`.
///
/// Use the static methods to log through the shared default logger,
/// or create an instance to log under a dedicated category:
///
///     let log = Log(category: "Network")
///     log.info("Request started")
public struct Log: Sendable {

    private let logger: Logger

    /// Creates a logger for a dedicated category.
    /// - Parameters:
    ///   - subsystem: The subsystem identifier. Defaults to the configured
    ///     subsystem (the main bundle identifier unless changed via
    ///     ``configure(subsystem:category:)``).
    ///   - category: The category for the logs.
    public init(subsystem: String? = nil, category: String) {
        logger = Logger(subsystem: subsystem ?? Self.storage.subsystem, category: category)
    }

    public func info(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.info("\(formatted, privacy: .public)")
    }

    public func warning(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.warning("\(formatted, privacy: .public)")
    }

    public func error(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.error("\(formatted, privacy: .public)")
    }

    public func error(
        _ error: Error,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(String(describing: error), file: file, function: function, line: line)
        logger.error("\(formatted, privacy: .public)")
    }

    public func debug(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.debug("\(formatted, privacy: .public)")
        #endif
    }

    public func fault(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.fault("\(formatted, privacy: .public)")
    }

    public func trace(
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        logger.trace("→ [\(Self.fileName(file), privacy: .public):\(line, privacy: .public) \(function, privacy: .public)]")
        #endif
    }

    // MARK: - Formatting

    static func format(_ message: String, file: String, function: String, line: Int) -> String {
        "[\(fileName(file)):\(line) \(function)] \(message)"
    }

    static func fileName(_ file: String) -> String {
        file.split(separator: "/").last.map(String.init) ?? file
    }

    // MARK: - Shared default logger

    private final class Storage: @unchecked Sendable {
        private let lock = NSLock()
        private var _subsystem = Bundle.main.bundleIdentifier ?? "App"
        private var _category = "General"
        private var cached: Log?

        var subsystem: String {
            lock.lock()
            defer { lock.unlock() }
            return _subsystem
        }

        var current: Log {
            lock.lock()
            defer { lock.unlock() }
            if let cached { return cached }
            let log = Log(subsystem: _subsystem, category: _category)
            cached = log
            return log
        }

        func configure(subsystem: String, category: String) {
            lock.lock()
            defer { lock.unlock() }
            _subsystem = subsystem
            _category = category
            cached = nil
        }
    }

    private static let storage = Storage()

    /// Configures the shared default logger with a specific subsystem and category.
    /// - Parameters:
    ///   - subsystem: The subsystem identifier (usually the bundle ID).
    ///   - category: The category for the logs.
    public static func configure(subsystem: String, category: String) {
        storage.configure(subsystem: subsystem, category: category)
    }

    public static func info(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.info(message(), file: file, function: function, line: line)
    }

    public static func warning(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.warning(message(), file: file, function: function, line: line)
    }

    public static func error(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.error(message(), file: file, function: function, line: line)
    }

    public static func error(
        _ error: Error,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.error(error, file: file, function: function, line: line)
    }

    public static func debug(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        storage.current.debug(message(), file: file, function: function, line: line)
        #endif
    }

    public static func fault(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.fault(message(), file: file, function: function, line: line)
    }

    public static func trace(
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        storage.current.trace(file: file, function: function, line: line)
        #endif
    }
}
