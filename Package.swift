// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageDownloaderFramework",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ImageDownloaderFramework",
            targets: ["ImageDownloaderFramework"]),
    ],
    dependencies: [
        // Add dependencies if needed
    ],
    targets: [
        .target(
            name: "ImageDownloaderFramework",
            dependencies: [],
            path: "Sources/ImageDownloaderFramework"
        ),
        .testTarget(
            name: "ImageDownloaderFrameworkTests",
                       dependencies: ["ImageDownloaderFramework"],
                       path: "Tests",
                       resources: [.process("Assets.xcassets")]
        ),
    ]
)
