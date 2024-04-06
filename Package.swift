// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CompactKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "FoundationExtension", targets: ["FoundationExtension"]),
        .library(name: "SwiftUIExtension", targets: ["SwiftUIExtension"]),
        .library(name: "UIKitExtension", targets: ["UIKitExtension"]),
        .library(name: "Provider", targets: ["Provider"]),
        .library(name: "Provider+AsyncAwait", targets: ["Provider+AsyncAwait"]),
        .library(name: "Provider+Rx", targets: ["Provider+Rx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0"))
    ],
    targets: [
        .target(
            name: "FoundationExtension",
            path: "Sources/Extension/Foundation"
        ),
        .target(
            name: "SwiftUIExtension",
            path: "Sources/Extension/SwiftUI"
        ),
        .target(
            name: "UIKitExtension",
            path: "Sources/Extension/UIKit"
        ),
        .target(
            name: "Provider",
            dependencies: [
                .product(name: "Moya", package: "Moya"),
                "FoundationExtension"
            ]
        ),
        .target(
            name: "Provider+AsyncAwait",
            dependencies: ["Provider"]
        ),
        .target(
            name: "Provider+Rx",
            dependencies: [
                "Provider",
                "UIKitExtension",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxMoya", package: "Moya")
            ]
        )
//        .testTarget(
//            name: "CompactKitTests",
//            dependencies: ["CompactKit"]
//        ),
    ]
)
