// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Wisbee",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Wisbee",
            targets: ["Wisbee"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Wisbee",
            dependencies: [],
            path: "Wisbee",
            sources: ["App/WisbeeApp.swift", "App/ContentView.swift"]
        ),
        .testTarget(
            name: "WisbeeTests",
            dependencies: ["Wisbee"]),
    ]
)