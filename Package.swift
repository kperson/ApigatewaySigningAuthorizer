// swift-tools-version:5.0.0
import PackageDescription

let package = Package(
    name: "apigateway-signing-authorizer",
    products: [
        .library(name: "ApigatewaySigningAuthorizer", targets: ["ApigatewaySigningAuthorizer"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-aws/aws-sdk-swift.git", .upToNextMinor(from: "3.1.0")),
        .package(url: "https://github.com/kperson/swift-lambda-tools.git", .branch("master")),
        .package(url: "https://github.com/MakeAWishFoundation/SwiftyMocky", .upToNextMinor(from: "3.3.3")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "ApigatewaySigningAuthorizerApp",
            dependencies: [
                "ApigatewaySigningAuthorizer"
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
                "ApigatewaySigningAuthorizer",
                "SwiftyMocky"
            ]
        )
    ]
)
