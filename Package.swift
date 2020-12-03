// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartlookConsentSDK",
    platforms: [
        SupportedPlatform.iOS(.v10),
        SupportedPlatform.macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SmartlookConsentSDK",
            targets: ["SmartlookConsentSDK"])
    ],
    targets: [
        .target(
            name: "SmartlookConsentSDK",
            path: "Sources")
    ]
)
