// swift-tools-version:5.0.0
import PackageDescription

let package = Package(
    name: "apigateway-signing-authorizer",
    products: [
        .library(name: "ApigatewaySigningAuthorizer", targets: ["ApigatewaySigningAuthorizer"]),
        .library(name: "VaporBodySigning", targets: ["VaporBodySigning"])
    ],
    dependencies: [
        .package(url: "https://github.com/kperson/swift-lambda-tools.git", .branch("master")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "1.1.0")),
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "3.3.0"))
    ],
    targets: [
        .target(
            name: "ApigatewaySigningAuthorizerApp",
            dependencies: [
                "ApigatewaySigningAuthorizer"
            ]
        ),
        .target(
            name: "VaporBodySigning",
            dependencies: [
                "Vapor",
                "CryptoSwift"
            ]
        ),
        .target(
            name: "ApigatewaySigningAuthorizer",
            dependencies: [
                "SwiftAWS",
                "CryptoSwift"
            ]
        ),
        .testTarget(
            name: "ApigatewaySigningAuthorizerTests",
            dependencies: [
                "ApigatewaySigningAuthorizer"
            ]
        )
    ]
)
