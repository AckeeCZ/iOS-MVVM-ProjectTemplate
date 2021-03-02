//
//  BaseViewModel.swift
//  ProjectTemplate
//
//  Created by Jan Misar on 16.08.18.
//

import Foundation
import os.log

/// Base class for all view models contained in app.
class BaseViewModel {

    static var logEnabled: Bool = true

    init() {
        if BaseViewModel.logEnabled {
            os_log("🧠 👶 %@", log: Logger.lifecycleLog(), type: .info, "\(self)")
        }
    }

    deinit {
        if BaseViewModel.logEnabled {
            os_log("🧠 ⚰️ %@", log: Logger.lifecycleLog(), type: .info, "\(self)")
        }
    }
}
