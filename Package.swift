import PackageDescription

let package = Package(
    name: "pakdatdomein",
    dependencies: [
        .Package(url: "https://github.com/vapor/json.git", majorVersion: 1),
        .Package(url: "https://github.com/Evertt/Timepiece.git", majorVersion: 1)
    ]
)
