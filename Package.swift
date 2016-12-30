import PackageDescription

let package = Package(
    name: "GrijpDatDomein",
    dependencies: [
        .Package(url: "https://github.com/Evertt/Timepiece.git", majorVersion: 1)
    ]
)
