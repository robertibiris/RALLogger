//
//  RALLogger.swift
//
//  Created by Roberto Arreaza on 22/8/24.
//

import Foundation

public class Logger {
    static let shared = Logger(topLevel: .info)
    ///When `true`, logs will also appear in the physical device's logs.
    var logsIntoConsole: Bool = false
    
    var topLevel: LogLevel
    
    /// initializes a RALLogger with a maximum loggin level
    /// - Parameter topLevel: the highest level of events to log. (the higher => the more events will be logged)
    init(topLevel: LogLevel = .info) {
        self.topLevel = topLevel
    }
    
    func log(_ message: String, level: LogLevel = .info, function: String = #function, file: String = #file, line: Int = #line) {
        
        if level.rawValue <= self.topLevel.rawValue {
            let fileName = file.components(separatedBy: "/").last ?? ""
            let logContent = "\(fileName)[\(line)] - \(function)\n\(level.icon): \(message)"
            if self.logsIntoConsole {
                NSLog(logContent)
            } else {
                #if DEBUG
                print(logContent)
                #endif
            }
        }
    }
    
    /// Same as log(), but fails right afterwards (using AssertionFailure). This SHOULD NOT impact release builds.
    func logAndFail(_ message: String, level: LogLevel = .info, function: String = #function, file: String = #file, line: Int = #line) {
        
        self.log(message, level: level, function: function, file: file, line: line)
        assertionFailure(message)
    }
    
    /// assert a given condition and logAndFail if it's not met. This SHOULD NOT impact release builds.
    func assert(_ condition: Bool, failureMessage message: String, level: LogLevel = .info, function: String = #function, file: String = #file, line: Int = #line) {
        
        if !condition {
            self.logAndFail(message, level: level, function: function, file: file, line: line)
        }
    }
}

extension Logger {
    enum LogLevel: UInt {
        case critical   = 0
        case error      = 1
        case warning    = 2
        case info       = 3
        case debug      = 4

        fileprivate var icon: String {
            switch self {
            case .debug: return "🐞"
            case .info: return "💬"
            case .warning: return "⚠️"
            case .error: return "📛"
            case .critical: return "🚨"
            }
        }
    }
}
