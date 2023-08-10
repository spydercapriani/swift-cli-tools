import ProjectDescription

let project = Project(
  name: "swift-cli-tools",
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2
    )
  ),
  packages: [
    .local(path: .relativeToRoot(".")),
    .remote(url: "https://github.com/apple/swift-argument-parser.git", requirement: .upToNextMajor(from: "1.2.0")),
  ],
  targets: [
    Target(
      name: "demo",
      platform: .macOS,
      product: .commandLineTool,
      bundleId: "edu.demo",
      sources: [ "Demo/**" ],
      scripts: [
        .pre(
          script: "rm -f ~/.local/bin/demo",
          name: "Remove Previous Binary"
        ),
        .post(
          script: "cp $BUILT_PRODUCTS_DIR/demo ~/.local/bin",
          name: "Copy Binary"
        )
      ],
      dependencies: [
        .package(product: "CLITools"),
        .package(product: "ArgumentParser"),
      ]
    ),
  ]
)
