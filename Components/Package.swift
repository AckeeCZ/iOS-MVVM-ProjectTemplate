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
        .library(
            name: "UI",
            targets: ["UI"]
        ),
        .library(
            name: "VersionUpdate",
            targets: ["VersionUpdate"]
        ),
        .library(
            name: "FirebaseFetcher",
            targets: ["FirebaseFetcher"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            .upToNextMajor(from: "10.12.0")
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
        .target(name: "UI"),
        .target(
            name: "VersionUpdate",
            dependencies: ["Networking"]
        ),
        .testTarget(
            name: "VersionUpdateTests",
            dependencies: ["VersionUpdate"]
        ),
        .target(
            name: "FirebaseFetcher",
            dependencies: [
                "VersionUpdate",
                .product(
                    name: "FirebaseRemoteConfigSwift",
                    package: "firebase-ios-sdk"
                ),
            ]
        )
    ]
)
