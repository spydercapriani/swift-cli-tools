//
//  Shell.swift
//  
//
//  Created by Danny Gilbert on 6/5/23.
//

import Foundation
import TSCBasic

public typealias Command = TSCBasic.Process

public enum Shell {
  
  @discardableResult
  public static func run(
    _ command: Command
  ) throws -> String {
    try command.launch()
    return try command.waitUntilExit()
      .utf8Output()
  }
}

extension Command: Swift.ExpressibleByStringLiteral {
  
  public convenience init(stringLiteral value: StringLiteralType) {
    self.init(arguments: value.components(separatedBy: .whitespaces))
  }
}
