import UserNotifications

struct PushNotification {
    struct Payload {

    }

    enum Action {

    }

    let action: Action?
    let payload: Payload
}

extension PushNotification {
    init?(response: UNNotificationResponse) {
        guard let payload = Payload(notification: response.notification) else { return nil }

        self.payload = payload
        self.action = Action(actionID: response.actionIdentifier)
    }
}

extension PushNotification.Action {
    init?(actionID: String) {
        return nil // TODO: Implement if any actions, probably add String as rawValue and delegate to `init(rawValue:)`
    }
}

extension PushNotification.Payload {
    init?(notification: UNNotification) {
        return nil // TODO: Implement payload mapping
    }
}

