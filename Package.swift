// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SFSymbols",
    platforms: [.macOS(.v11), .iOS(.v13), .macCatalyst(.v13), .watchOS(.v6), .tvOS(.v13), .visionOS(.v1)],
    products: [
        .library(
            name: "SFSymbols",
            targets: ["SFSymbols"]
        ),
    ],
    targets: [
        .target(
            name: "SFSymbols"
        ),
        .testTarget(
            name: "SFSymbolsTests",
            dependencies: ["SFSymbols"]
        ),
    ]
)
