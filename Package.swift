// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "AckeeTemplate",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "AckeeTemplate",
            targets: ["AckeeTemplate"]
        ),
        .library(
            name: "PushNotifications",
            targets: ["PushNotifications"]
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
        .target(name: "AckeeTemplate"),
        .testTarget(
            name: "AckeeTemplateTests",
            dependencies: ["AckeeTemplate"]
        ),
        .target(name: "PushNotifications"),
        .testTarget(
            name: "PushNotificationsTests",
            dependencies: ["PushNotifications"]
        ),
        .target(
            name: "FirebaseFetcher",
            dependencies: [
                "AckeeTemplate",
                .product(
                    name: "FirebaseRemoteConfigSwift",
                    package: "firebase-ios-sdk"
                ),
            ]
        )
    ]
)
