// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChirAI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ChirAI",
            targets: ["ChirAI"]),
    ],
    targets: [
        .target(
            name: "ChirAI",
            dependencies: [],
            path: "Sources"
        ),
    ]
)