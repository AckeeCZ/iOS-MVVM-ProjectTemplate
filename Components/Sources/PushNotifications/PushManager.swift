import Foundation
import UserNotifications

public protocol PushManaging {
    var actions: PushManagingActions { get }
    
    var notificationSettings: AsyncStream<UNNotificationSettings> { get }
    var currentNotificationSettings: UNNotificationSettings? { get }
}

public protocol PushManagingActions {
    func start()
    func requestPermission(options: UNAuthorizationOptions) async
    
    func addNotificationReceivedHandler(_ handler: @escaping (UNNotification) async -> ()) -> String
    func removeNotificationReceivedHandler(id: String)
    
    func addNotificationOpenedHandler(_ handler: @escaping (UNNotificationResponse) async -> ()) -> String
    func removeNotificationOpenedHandler(id: String)
}

public extension PushManaging where Self: PushManagingActions {
    var actions: PushManagingActions { self }
}

public final class PushManager: NSObject, PushManaging, PushManagingActions {
    public private(set) lazy var notificationSettings = AsyncStream<UNNotificationSettings> { continuation in
        notificationSettingsContinuation = continuation
        
        if let currentNotificationSettings {
            continuation.yield(currentNotificationSettings)
        }
    }
    public private(set) var currentNotificationSettings: UNNotificationSettings?
    
    public lazy var presentationOptions: (UNNotification) async -> UNNotificationPresentationOptions = { [weak self] notification in
        guard let self else { return [] }
        return await notificationCenter.notificationSettings().allowedPresentationOptions
    }
    
    public var openSettings: (UNNotification?) -> () = { _ in }
    
    private let notificationCenter: UNUserNotificationCenter
    private var notificationSettingsContinuation: AsyncStream<UNNotificationSettings>.Continuation?
    
    private var notificationReceivedHandlers = [String: (UNNotification) async -> ()]()
    private var notificationOpenedHandlers = [String: (UNNotificationResponse) async -> ()]()
    
    public init(
        notificationCenter: UNUserNotificationCenter = .current()
    ) {
        self.notificationCenter = notificationCenter
        super.init()
    }
    
    deinit {
        notificationSettingsContinuation?.finish()
    }
    
    public func start() {
        notificationCenter.delegate = self
    }
    
    public func requestPermission(options: UNAuthorizationOptions) async {
        guard let granted = try? await notificationCenter.requestAuthorization(options: options),
              granted
        else { return }
        
        let settings = await notificationCenter.notificationSettings()
        currentNotificationSettings = settings
        notificationSettingsContinuation?.yield(settings)
    }
    
    public func addNotificationReceivedHandler(
        _ handler: @escaping (UNNotification) async -> ()
    ) -> String {
        let id = UUID().uuidString
        notificationReceivedHandlers[id] = handler
        return id
    }
    
    public func removeNotificationReceivedHandler(id: String) {
        notificationReceivedHandlers[id] = nil
    }
    
    public func addNotificationOpenedHandler(
        _ handler: @escaping (UNNotificationResponse) async -> ()
    ) -> String {
        let id = UUID().uuidString
        notificationOpenedHandlers[id] = handler
        return id
    }
    
    public func removeNotificationOpenedHandler(id: String) {
        notificationOpenedHandlers[id] = nil
    }
}

extension PushManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        for handler in notificationReceivedHandlers.values {
            await handler(notification)
        }
        
        return await presentationOptions(notification)
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        for handler in notificationOpenedHandlers.values {
            await handler(response)
        }
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {
        openSettings(notification)
    }
}
