// Log.swift
// MIT License

import Foundation

public final class Log {

    public enum Level: String {
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        case debug = "DEBUG"
    }

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        f.locale = .autoupdatingCurrent
        return f
    }()

    public static func message(
        _ message: String,
        level: Level = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let timestamp = formatter.string(from: Date())

        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(timestamp)] [\(level.rawValue)] \(fileName):\(line) \(function) -> \(message)")
        #else
        guard level != .debug else { return }
        print("[\(timestamp)] [\(level.rawValue)] \(message)")
        #endif
    }
}
