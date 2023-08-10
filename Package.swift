// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "swift-cli-tools",
  products: [
    .library(
      name: "CLITools",
      targets: [
        "ConsoleUI",
        "Shell",
      ]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.5.2"),
  ],
  targets: [
    .target(
      name: "ConsoleUI",
      dependencies: [
        .product(
          name: "SwiftToolsSupport",
          package: "swift-tools-support-core"
        ),
      ],
      path: "Sources/UI"
    ),
    .target(
      name: "Shell",
      dependencies: [
        .product(
          name: "SwiftToolsSupport",
          package: "swift-tools-support-core"
        ),
      ]
    ),
  ]
)
