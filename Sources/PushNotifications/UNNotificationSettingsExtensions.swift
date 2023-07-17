import UserNotifications

public extension UNNotificationSettings {
    var allowedPresentationOptions: UNNotificationPresentationOptions {
        .init([
            (badgeSetting, UNNotificationPresentationOptions.badge),
            (soundSetting, .sound),
            (alertSetting, .alert),
        ].compactMap { setting, option in
            if setting == .enabled { return option }
            return nil
        })
    }
}
