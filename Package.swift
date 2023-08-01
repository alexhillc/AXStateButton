// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AXStateButton",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "AXStateButton",
            targets: ["AXStateButton"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AXStateButton",
            dependencies: [],
            path: "Source",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
            ]
        )
    ]
)
