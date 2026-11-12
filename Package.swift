// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "compiler",
    platforms: [.macOS("27.0.0")],
    products: [.executable(name: "compiler", targets: ["compiler"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-system", from: "1.7.0"),
        .package(url: "https://github.com/DanielJamesHeywood/llvm-swift", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "compiler",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "LLVM", package: "llvm-swift"),
                "Lexing",
                "Parsing",
                "SemanticAnalysis",
                "IRGeneration"
            ]
        ),
        .target(
            name: "Lexing",
            dependencies: ["Tokens"]
        ),
        .target(
            name: "Parsing",
            dependencies: ["Tokens", "Syntax"]
        ),
        .target(
            name: "SemanticAnalysis",
            dependencies: ["Tokens", "Syntax", "Semantics"]
        ),
        .target(
            name: "IRGeneration",
            dependencies: [.product(name: "LLVM", package: "llvm-swift"), "Tokens", "Syntax", "Semantics"]
        ),
        .target(
            name: "Tokens"
        ),
        .target(
            name: "Syntax",
            dependencies: ["Tokens"]
        ),
        .target(
            name: "Semantics",
            dependencies: ["Tokens", "Syntax"]
        )
    ]
)
