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
        .library(name: "SwiftUIView", targets: ["SwiftUIView"]),
        .library(name: "UIKitView", targets: ["UIKitView"]),
        .library(name: "CustomView", targets: ["CustomView"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.7.1")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "11.4.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.25.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.11.0"))
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
                "FoundationExtension",
                .product(name: "Moya", package: "Moya")
            ],
            path: "Sources/Provider/Base"
        ),
        .target(
            name: "Provider+AsyncAwait",
            dependencies: [
                "Provider"
            ],
            path: "Sources/Provider/AsyncAwait"
        ),
        .target(
            name: "Provider+Rx",
            dependencies: [
                "Provider",
                "UIKitExtension",
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxMoya", package: "Moya")
            ],
            path: "Sources/Provider/Rx"
        ),
        .target(
            name: "SwiftUIView",
            dependencies: [
                "UIKitExtension",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "Sources/View/SwiftUI"
        ),
        .target(
            name: "UIKitView",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Sources/View/UIKit"
        ),
        .target(
            name: "CustomView",
            dependencies: [
                "SwiftUIExtension"
            ],
            path: "Sources/View/Custom"
        )
//        .testTarget(
//            name: "CompactKitTests",
//            dependencies: ["CompactKit"]
//        ),
    ]
)
