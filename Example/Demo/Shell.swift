//
//  Shell.swift
//
//
//  Created by Danny Gilbert on 8/9/23.
//

import Foundation
import ArgumentParser
import TSCBasic
import ConsoleUI
import Shell

struct ShellCommand: ParsableCommand {
  
  @Flag(name: .customShort("v"))
  var verbose: Bool = false
  
  static let configuration: CommandConfiguration = .init(
    commandName: "shell",
    abstract: "Highlights features of swift-cli-tools Shell library."
  )
  
  func run() throws {
    if verbose {
      Command.loggingHandler = { console.step($0) }
    }
    console.info(
      try Shell.run("pwd")
    )
    
    let result = try Shell.run("ls -l")
    console.info(result)
  }
}
