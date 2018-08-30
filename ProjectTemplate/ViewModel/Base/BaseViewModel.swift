//
//  BaseViewModel.swift
//  ProjectTemplate
//
//  Created by Jan Misar on 16.08.18.
//

import Foundation

class BaseViewModel {

    static var logEnabled: Bool = true

    init() {
        if BaseViewModel.logEnabled {
            NSLog("🧠 👶 \(self)")
        }
    }

    deinit {
        if BaseViewModel.logEnabled {
            NSLog("🧠 ⚰️ \(self)")
        }
    }
}
