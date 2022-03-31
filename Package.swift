// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XJTableViewManager",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "XJTableViewManager",
            targets: ["XJTableViewManager"]),
    ],
    targets: [
        .target(
            name: "XJTableViewManager",
            path: "Sources",
            publicHeadersPath: "."),
    ]
)
