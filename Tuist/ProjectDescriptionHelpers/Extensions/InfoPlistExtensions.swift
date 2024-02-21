import AckeeTemplate
import ProjectDescription

extension InfoPlist {
    private static var _sharedDefault: [String: Plist.Value] {
        [
            "CFBundleVersion": .string(String(Shell.numberOfCommits() ?? 1)),
            "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        ]
    }
    
    static var sharedDefault: InfoPlist {
        .extendingDefault(with: _sharedDefault)
    }
    
    static func extendingSharedDefault(
        with dictionary: [String: Plist.Value]
    ) -> InfoPlist {
        .extendingDefault(with: _sharedDefault.merging(dictionary) { $1 })
    }
}

import ProjectDescription
