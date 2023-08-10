//
//  Demo.swift
//
//
//  Created by Danny Gilbert on 6/1/23.
//

import Foundation
import ArgumentParser

@main
struct Demo: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "demo",
    abstract: "Demo command-line tool for highlighting features of swift-cli-tools library",
    subcommands: [
      UI.self,
      ShellCommand.self,
    ],
    defaultSubcommand: UI.self
  )
}
