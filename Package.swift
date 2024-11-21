// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwipeliveCapacitorAgora",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwipeliveCapacitorAgora",
            targets: ["AgoraPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "AgoraPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/AgoraPlugin"),
        .testTarget(
            name: "AgoraPluginTests",
            dependencies: ["AgoraPlugin"],
            path: "ios/Tests/AgoraPluginTests")
    ]
)