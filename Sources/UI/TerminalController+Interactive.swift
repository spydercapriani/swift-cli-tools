//
//  TerminalController+Interactive.swift
//  
//
//  Created by Danny Gilbert on 6/1/23.
//

import Foundation
import TSCBasic

public extension TerminalController {
  
  func wait(
    _ msg: String = "Press any key to continue...",
    inColor color: TerminalController.Color = .green,
    bold: Bool = true
  ) {
    bot(msg, inColor: color, bold: bold, endLine: false)
    _ = getKeypress()
    endLine()
  }
  
  func confirm(
    _ msg: String = "",
    inColor color: TerminalController.Color = .green,
    bold: Bool = true
  ) -> Bool {
    bot("\(msg)\n(Y)es | (N)o", inColor: color, bold: bold, endLine: false)
    let key = getKeypress()
    endLine()
    let scalar = UnicodeScalar(key)
    let value = Character(scalar).uppercased()
    
    if value == "Y" {
      return true
    } else if value == "N" {
      return false
    } else {
      error("Please enter a valid character!", bold: true)
      return confirm(msg, inColor: color, bold: bold)
    }
  }
  
  func prompt(
    _ msg: String,
    inColor color: TerminalController.Color = .noColor,
    bold: Bool = true,
    isSecure: Bool = false
  ) -> String {
    bot(msg + ": ", inColor: color, bold: bold, endLine: false)
    
    var buf = [CChar](repeating: 0, count: 8192)
    if isSecure {
      guard
        let passphrase = readpassphrase("", &buf, buf.count, 0),
        let secureText = String(validatingUTF8: passphrase)
      else {
        error("Could not read from secure entry...")
        return prompt(msg, inColor: color, bold: bold, isSecure: isSecure)
      }
      return secureText
    } else {
      guard
        let text = readLine()
      else {
        error("Could not read entry...")
        return prompt(msg, inColor: color, bold: bold, isSecure: isSecure)
      }
      return text
    }
  }
}

extension FileHandle {
  
  func enableRawMode() -> termios {
    var raw = termios()
    tcgetattr(self.fileDescriptor, &raw)
    
    let original = raw
    raw.c_lflag &= ~UInt(ECHO | ICANON)
    tcsetattr(self.fileDescriptor, TCSADRAIN, &raw)
    return original
  }
  
  func restoreRawMode(originalTerm: termios) {
    var term = originalTerm
    tcsetattr(self.fileDescriptor, TCSADRAIN, &term)
  }
}

func getKeypress() -> UInt8 {
  let handle = FileHandle.standardInput
  let term = handle.enableRawMode()
  defer { handle.restoreRawMode(originalTerm: term) }
  
  var byte: UInt8 = 0
  read(handle.fileDescriptor, &byte, 1)
  return byte
}
