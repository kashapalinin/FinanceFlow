// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServicesImpl",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ServicesImpl",
            targets: ["ServicesImpl"]
        ),
    ],
    dependencies: [
        .package(path: "/Users/pavelkalinin/Desktop/FinanceFlow/FinanceFlow/Modules/Core/Services/ServicesAPI"),
        .package(path: "/Users/pavelkalinin/Desktop/FinanceFlow/FinanceFlow/Modules/Core/Storage/StorageAPI"),
        .package(path: "/Users/pavelkalinin/Desktop/FinanceFlow/FinanceFlow/Modules/Core/Domain/Domain"),
        .package(url: "https://github.com/kashapalinin/CurrencyFormatter.git", from: "1.1.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ServicesImpl",
            dependencies: ["ServicesAPI", "StorageAPI", "CurrencyFormatter", "Domain"]
        ),
        .testTarget(
            name: "ServicesImplTests",
            dependencies: ["ServicesImpl"]
        ),
    ]
)
