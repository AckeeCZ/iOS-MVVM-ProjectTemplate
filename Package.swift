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
            name: "FirebaseFetcher",
            targets: ["FirebaseFetcher"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            .upToNextMajor(from: "10.19.0")
        ),
        .package(
            url: "https://github.com/AckeeCZ/ACKategories",
            .upToNextMajor(from: "6.13.0")
        ),
    ],
    targets: [
        .target(
            name: "FirebaseFetcher",
            dependencies: [
                .product(
                    name: "ACKategories",
                    package: "ACKategories"
                ),
                .product(
                    name: "FirebaseRemoteConfig",
                    package: "firebase-ios-sdk"
                ),

            ]
        )
    ]
)
