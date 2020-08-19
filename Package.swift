// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "pakdatdomein",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/Evertt/Timepiece", from: "1.3.2"),
        .package(url: "https://github.com/nerdsupremacist/GraphZahl.git", from: "0.1.0-alpha."),
        // .package(url: "https://github.com/nerdsupremacist/graphzahl-vapor-support.git", from: "0.1.0-alpha."),
    ],
    targets: [
        .target(name: "Framework"),
        .target(
            name: "Model",
            dependencies: ["Framework", "Timepiece", "GraphZahl"]
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model", "Framework", "GraphZahl"]
        ),
    ]
)
