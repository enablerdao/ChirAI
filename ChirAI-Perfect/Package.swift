// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChirAI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "ChirAI", targets: ["ChirAI"])
    ],
    targets: [
        .executableTarget(
            name: "ChirAI",
            dependencies: [],
            path: "Sources"
        )
    ]
)
