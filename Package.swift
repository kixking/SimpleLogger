// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleLogger",
    platforms: [
        .iOS(.v15),         // iPhone / iPad
        .macOS(.v12),       // macOS Monterey
        .tvOS(.v15),        // Apple TV
        .watchOS(.v8),      // Apple Watch
        .visionOS(.v1)      // Apple Vision Pro
    ],
    products: [
        .library(
            name: "SimpleLogger",
            targets: ["SimpleLogger"]
        ),
    ],
    targets: [
        .target(
            name: "SimpleLogger"
        ),
        .testTarget(
            name: "SimpleLoggerTests",
            dependencies: ["SimpleLogger"]
        ),
    ]
)
