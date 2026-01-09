// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseServicesImpl",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FirebaseServicesImpl",
            targets: ["FirebaseServicesImpl"]
        ),
    ],
    dependencies: [
        .package(path: "/Users/pavelkalinin/Desktop/FinanceFlow/FinanceFlow/Modules/Core/FirebaseServices/FirebaseServicesAPI"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FirebaseServicesImpl",
            dependencies: [
                "FirebaseServicesAPI",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "FirebaseServicesImplTests",
            dependencies: ["FirebaseServicesImpl"]
        ),
    ]
)
