// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SmartlookConsentSDK",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "SmartlookConsentSDK",
            targets: ["SmartlookConsentSDK"])
    ],
    targets: [
        .target(
            name: "SmartlookConsentSDK",
            path: "Sources",
            exclude: ["Info.plist"])
    ]
)
