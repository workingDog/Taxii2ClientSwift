// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Taxii2Client",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Taxii2Client",
            targets: ["Taxii2Client"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "PromiseKit", url: "https://github.com/mxcl/PromiseKit.git", from: "6.13.1"),
        .package(name: "PMKFoundation", url: "https://github.com/PromiseKit/Foundation.git", from: "3.3.4"),
        .package(name: "GenericJSON", url: "https://github.com/zoul/generic-json-swift.git", from: "2.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Taxii2Client",
            dependencies: ["PromiseKit", "PMKFoundation", "GenericJSON"]),

    ]
)
