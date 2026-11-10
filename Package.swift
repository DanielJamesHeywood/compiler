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
                .product(name: "LLVM", package: "llvm-swift"),
                .product(name: "SystemPackage", package: "swift-system"),
                "Lexing",
                "Parsing",
                "SemanticAnalysis"
            ]
        ),
        .target(
            name: "IRGeneration",
            dependencies: [.product(name: "LLVM", package: "llvm-swift"), "Semantics", "Syntax", "Tokens"]
        ),
        .target(
            name: "Lexing",
            dependencies: ["Tokens"]
        ),
        .target(
            name: "Parsing",
            dependencies: ["Syntax", "Tokens"]
        ),
        .target(
            name: "SemanticAnalysis",
            dependencies: ["Semantics"]
        ),
        .target(
            name: "Semantics",
            dependencies: ["Syntax", "Tokens"]
        ),
        .target(
            name: "StandardLibrary",
            dependencies: ["Syntax", "Tokens"]
        ),
        .target(
            name: "Syntax",
            dependencies: ["Tokens"]
        ),
        .target(
            name: "Tokens"
        )
    ]
)
