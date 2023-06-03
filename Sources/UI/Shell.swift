//
//  Shell.swift
//  
//
//  Created by Danny Gilbert on 6/3/23.
//

import Foundation
import TSCBasic

public extension TerminalController {
  
  func shellCommand(_ command: String, workingDirectory: AbsolutePath? = nil) throws -> String {
    let process = Process()
    
    // Set the executable to zsh
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    
    // Set the working directory for the command to be ran from
    process.currentDirectoryURL = workingDirectory?.asURL
    
    // Set the command to be executed
    process.arguments = ["-c", command]
    
    // Create a pipe for capturing the command's output
    let pipe = Pipe()
    process.standardOutput = pipe
    
    try process.run()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard
      let output = String(data: data, encoding: .utf8)
    else {
      throw "Error processing command output"
    }
    return output.trimmingCharacters(in: .newlines)
  }
}

extension String: Error { }
