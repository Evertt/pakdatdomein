// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "pakdatdomein",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/Evertt/Timepiece", from: "1.3.2"),
    ],
    targets: [
        .target(name: "Framework"),
        .target(
            name: "Model",
            dependencies: ["Framework", "Timepiece"]
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model", "Framework"]
        ),
    ]
)
