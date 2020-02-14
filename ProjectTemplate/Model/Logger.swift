//
//  Logger.swift
//  ProjectTemplate
//
//  Created by Marek Fořt on 1/10/19.
//

import Foundation
import os.log

/// Contains pre-defined OSLog categories
struct LoggerCategory {
    /// Generic app logging category
    static var app: String { "App" }
    /// Networking logging category
    static var networking: String { "Networking" }
    /// Lifecycle logging category
    static var lifecycle: String { "Lifecycle" }
}

/// Wrapper class for os_log function
struct Logger {
    /// Create OSLog with subsystem and category
    static func osLog(subsystem: String = Bundle.main.bundleIdentifier ?? "-", category: String) -> OSLog {
        OSLog(subsystem: subsystem, category: category)
    }

    /// Create app log
    static func appLog() -> OSLog {
        OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.app)
    }

    /// Create networking log
    static func networkingLog() -> OSLog {
        OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.networking)
    }

    /// Create lifecycle log
    static func lifecycleLog() -> OSLog {
        OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: LoggerCategory.lifecycle)
    }
}
