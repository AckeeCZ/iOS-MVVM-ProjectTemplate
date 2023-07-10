// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "Components",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
        .library(
            name: "PushNotifications",
            targets: ["PushNotifications"]
        ),
    ],
    targets: [
        .target(name: "Networking"),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]
        ),
        .target(name: "PushNotifications"),
        .testTarget(
            name: "PushNotificationsTests",
            dependencies: ["PushNotifications"]
        ),
    ]
)
