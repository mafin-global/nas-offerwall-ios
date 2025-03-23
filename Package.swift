// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NasWallKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NasWallKit",
            targets: ["NasWallKit"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "NasWallKit",
            path: "sdk/NasWallKit.xcframework"
        ),
    ]
)
