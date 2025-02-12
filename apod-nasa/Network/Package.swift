// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v15)  // 🟢 Define iOS 15 como mínimo
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        ),
    ],
    targets: [
        .target(
            name: "Network"
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
    ]
)
