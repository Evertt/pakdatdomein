// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "pakdatdomein",
    dependencies: [
        .package(url: "https://github.com/Evertt/Timepiece", from: "1.3.2"),
    ],
    targets: [
        .target(name: "Framework"),
        .target(
            name: "Domain",
            dependencies: ["Framework", "Timepiece"]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain", "Framework"]
        ),
    ]
)
