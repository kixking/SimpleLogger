// Log.swift
// MIT License

#if canImport(os)
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

    @usableFromInline
    let logger: Logger

    /// Creates a logger for a dedicated category.
    /// - Parameters:
    ///   - subsystem: The subsystem identifier. Defaults to the configured
    ///     subsystem (the main bundle identifier unless changed via
    ///     ``configure(subsystem:category:)``).
    ///   - category: The category for the logs.
    @inlinable
    public init(subsystem: String? = nil, category: String) {
        logger = Logger(subsystem: subsystem ?? Self.storage.subsystem, category: category)
    }

    @inlinable
    public func info(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.info("\(formatted, privacy: .public)")
    }

    @inlinable
    public func warning(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.warning("\(formatted, privacy: .public)")
    }

    @inlinable
    public func error(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.error("\(formatted, privacy: .public)")
    }

    @inlinable
    public func error(
        _ error: Error,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(String(describing: error), file: file, function: function, line: line)
        logger.error("\(formatted, privacy: .public)")
    }

    @inlinable
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

    @inlinable
    public func fault(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let formatted = Self.format(message(), file: file, function: function, line: line)
        logger.fault("\(formatted, privacy: .public)")
    }

    @inlinable
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

    @usableFromInline
    static func format(_ message: String, file: String, function: String, line: Int) -> String {
        "[\(fileName(file)):\(line) \(function)] \(message)"
    }

    @usableFromInline
    static func fileName(_ file: String) -> Substring {
        if let lastSlashIndex = file.lastIndex(of: "/") {
            return file[file.index(after: lastSlashIndex)...]
        }
        return file[...]
    }

    // MARK: - Low-latency synchronization lock

    @usableFromInline
    final class UnfairLock: @unchecked Sendable {
        @usableFromInline
        let _lock: UnsafeMutablePointer<os_unfair_lock>

        @usableFromInline
        init() {
            _lock = UnsafeMutablePointer<os_unfair_lock>.allocate(capacity: 1)
            _lock.initialize(to: os_unfair_lock())
        }

        deinit {
            _lock.deinitialize(count: 1)
            _lock.deallocate()
        }

        @inlinable
        func lock() {
            os_unfair_lock_lock(_lock)
        }

        @inlinable
        func unlock() {
            os_unfair_lock_unlock(_lock)
        }
    }

    // MARK: - Shared default logger

    @usableFromInline
    final class Storage: @unchecked Sendable {
        @usableFromInline let lock = UnfairLock()
        @usableFromInline var _subsystem = Bundle.main.bundleIdentifier ?? "App"
        @usableFromInline var _category = "General"
        @usableFromInline var cached: Log?

        @usableFromInline
        init() {}

        @inlinable
        var subsystem: String {
            lock.lock()
            defer { lock.unlock() }
            return _subsystem
        }

        @inlinable
        var current: Log {
            lock.lock()
            defer { lock.unlock() }
            if let cached { return cached }
            let log = Log(subsystem: _subsystem, category: _category)
            cached = log
            return log
        }

        @inlinable
        func configure(subsystem: String, category: String) {
            lock.lock()
            defer { lock.unlock() }
            _subsystem = subsystem
            _category = category
            cached = nil
        }
    }

    @usableFromInline
    static let storage = Storage()

    /// Configures the shared default logger with a specific subsystem and category.
    /// - Parameters:
    ///   - subsystem: The subsystem identifier (usually the bundle ID).
    ///   - category: The category for the logs.
    @inlinable
    public static func configure(subsystem: String, category: String) {
        storage.configure(subsystem: subsystem, category: category)
    }

    @inlinable
    public static func info(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.info(message(), file: file, function: function, line: line)
    }

    @inlinable
    public static func warning(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.warning(message(), file: file, function: function, line: line)
    }

    @inlinable
    public static func error(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.error(message(), file: file, function: function, line: line)
    }

    @inlinable
    public static func error(
        _ error: Error,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.error(error, file: file, function: function, line: line)
    }

    @inlinable
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

    @inlinable
    public static func fault(
        _ message: @autoclosure () -> String,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        storage.current.fault(message(), file: file, function: function, line: line)
    }

    @inlinable
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

#else
#error("SimpleLogger is only supported on Apple platforms where the 'os' module is available.")
#endif
