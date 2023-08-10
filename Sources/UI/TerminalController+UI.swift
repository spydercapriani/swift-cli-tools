//
//  TerminalController+UI.swift
//  
//
//  Created by Danny Gilbert on 6/1/23.
//

import TSCBasic

public extension TerminalController {
  
  func print(
    _ msg: String,
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    self.write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func line(
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = false
  ) {
    print(.init(repeating: "-", count: self.width), inColor: color, bold: bold)
  }
  
  func action(
    _ msg: String,
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = false
  ) {
    write("🔵 [action]\t", inColor: .cyan, bold: true)
    write(msg, inColor: color, bold: bold)
    endLine()
    line(inColor: .cyan)
  }
  
  func step(
    _ msg: String,
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    write(" ⇒ ", inColor: .gray, bold: true)
    write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func bot(
    _ msg: String,
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    write("[◕ ◡ ◕]", inColor: .cyan, bold: true)
    write(" - ", inColor: .noColor)
    write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func info(
    _ msg: String,
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    write("🔷 [info] ", inColor: .gray, bold: true)
    write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func warn(
    _ msg: String,
    inColor color: TerminalController.Color = .yellow,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    write("⚠️  [warning] ", inColor: .yellow, bold: true)
    write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func error(
    _ msg: String,
    inColor color: TerminalController.Color = .red,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    write("❌ [error] ", inColor: .red, bold: true)
    write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func success(
    _ msg: String,
    inColor color: TerminalController.Color = .green,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    write("✅ [success] ", inColor: .green, bold: true)
    write(msg, inColor: color, bold: bold)
    if endLine { self.endLine() }
  }
  
  func flipTable(
    inColor color: TerminalController.Color = .red,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    print("(╯°□°)╯︵ ┻━┻", inColor: color, bold: bold, endLine: endLine)
  }
  
  func setTable(
    inColor color: TerminalController.Color = .green,
    bold: Bool = false,
    endLine: Bool = true
  ) {
    print("┬─┬ノ( º _ ºノ)", inColor: color, bold: bold, endLine: endLine)
  }
}
