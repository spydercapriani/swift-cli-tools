//
//  Spinners.swift
//  
//
//  Created by Danny Gilbert on 6/2/23.
//

import Foundation
import TSCBasic
import TSCUtility

public protocol ProgressSpinnable {
  func start()
  func stop()
}

private var fps: useconds_t {
  let fps: Double = 1 / 60
  return useconds_t(fps * pow(1000, 2))
}

/// A single line progress bar spinner
final class SingleLineProgressSpinner: ProgressSpinnable {
  private let stream: OutputByteStream
  private let started: String?
  private let finished: String?
  private let isShowStopped: Bool
  private var spinner: Spinner
  private var isProgressing: Bool
  private var isClear: Bool
  private var displayed: Set<Int> = []
  
  private let queue: DispatchQueue
  private let sleepInterval: useconds_t
  
  init(
    stream: OutputByteStream,
    started: String? = nil,
    finished: String? = nil,
    isShowStopped: Bool,
    spinner: Spinner
  ) {
    self.stream = stream
    self.started = started
    self.finished = finished
    self.isShowStopped = isShowStopped
    self.spinner = spinner
    self.isProgressing = false
    self.isClear = true
    self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
    self.sleepInterval = fps * 100
  }
  
  func start() {
    isProgressing = true
    
    if isClear {
      stream <<< (started ?? "")
      stream <<< "\n"
      stream.flush()
      isClear = false
    }
    
    self.stream <<< (started ?? "")
    self.stream <<< "\n"
    
    queue.async { [weak self] in
      guard let self = self else { return }
      while self.isProgressing {
        self.stream <<< self.spinner.frame
        self.stream <<< "\n"
        self.stream.flush()
        
        usleep(self.sleepInterval)
      }
    }
  }
  
  func stop() {
    isProgressing = false
    if isShowStopped {
      stream <<< (finished ?? "")
      stream.flush()
    }
  }
}

final class SimpleProgressSpinner: ProgressSpinnable {
  private let stream: OutputByteStream
  private let started: String?
  private let finished: String?
  private let isShowStopped: Bool
  private var spinner: Spinner
  private var isProgressing: Bool
  private var isClear: Bool
  
  private let queue: DispatchQueue
  private let sleepInterval: useconds_t
  
  init(
    stream: OutputByteStream,
    started: String? = nil,
    finished: String? = nil,
    isShowStopped: Bool,
    spinner: Spinner
  ) {
    self.stream = stream
    self.started = started
    self.finished = finished
    self.isShowStopped = isShowStopped
    self.spinner = spinner
    self.isProgressing = false
    self.isClear = true
    self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
    self.sleepInterval = fps * 100
  }
  
  func start() {
    isProgressing = true
    
    if isClear {
      stream <<< (started ?? "")
      stream <<< "\n"
      stream.flush()
      isClear = false
    }
    
    queue.async { [weak self] in
      guard let self = self else {
        return
      }
      while self.isProgressing {
        self.stream <<< self.spinner.frame
        self.stream <<< "\n"
        self.stream.flush()
        
        usleep(self.sleepInterval)
      }
    }
  }
  
  func stop() {
    isProgressing = false
    if isShowStopped {
      self.stream <<< "Stop"
      self.stream <<< "\n"
      self.stream.flush()
    }
  }
}

final class ProgressSpinner: ProgressSpinnable {
  private let term: TerminalController
  private let started: String?
  private let finished: String?
  private let isShowStopped: Bool
  private var spinner: Spinner
  private var isProgressing: Bool
  
  private let queue: DispatchQueue
  private let sleepInterval: useconds_t
  
  init(
    term: TerminalController,
    started: String? = nil,
    finished: String? = nil,
    isShowStopped: Bool,
    spinner: Spinner
  ) {
    self.term = term
    self.started = started
    self.finished = finished
    self.isShowStopped = isShowStopped
    self.spinner = spinner
    self.isProgressing = false
    self.queue = DispatchQueue(label: "progressSpinnerQueue", qos: .background)
    self.sleepInterval = fps
  }
  
  func start() {
    isProgressing = true
    queue.async { [weak self] in
      guard let self = self else { return }
      
      while self.isProgressing {
        self.term.clearLine()
        self.term.write(self.spinner.frame, inColor: .green)
        if let msg = self.started {
          self.term.write(msg, inColor: .cyan, bold: true)
        }
        usleep(self.sleepInterval)
      }
    }
  }
  
  func stop() {
    isProgressing = false
    term.clearLine()
    if isShowStopped, let msg = self.finished {
      term.write(msg, inColor: .green, bold: true)
      term.endLine()
    }
  }
}

/// Creates colored or simple progress spinner based on the provided output stream.
public func createProgressSpinner(
  forStream stderrStream: ThreadSafeOutputByteStream,
  started: String? = nil,
  finished: String? = nil,
  isShowStopped: Bool = true,
  spinner: Spinner = Spinner(kind: .matrix)
) -> ProgressSpinnable {
  guard let stdStream = stderrStream.stream as? LocalFileOutputByteStream else {
    return SimpleProgressSpinner(
      stream: stderrStream.stream,
      started: started,
      finished: finished,
      isShowStopped: isShowStopped,
      spinner: spinner
    )
  }

  // If we have a terminal, use animated progress spinener.
  if let term = TerminalController(stream: stdStream) {
    return ProgressSpinner(
      term: term,
      started: started,
      finished: finished,
      isShowStopped: isShowStopped,
      spinner: spinner
    )
  }

  // If the terminal is dumb, use single line progress spinner.
  if TerminalController.terminalType(stdStream) == .dumb {
    return SingleLineProgressSpinner(
      stream: stderrStream.stream,
      started: started,
      finished: finished,
      isShowStopped: isShowStopped,
      spinner: spinner
    )
  }
  
  // Use simple progress spinner by default.
  return SimpleProgressSpinner(
    stream: stderrStream.stream,
    started: started,
    finished: finished,
    isShowStopped: isShowStopped,
    spinner: spinner
  )
}

public struct Spinner {
  private let kind: Kind
  private var cursor: Int
  
  public init(kind: Kind) {
    self.kind = kind
    self.cursor = 0
  }
  
  var frame: String {
    mutating get {
      defer {
        cursor += 1
      }
      return " " + kind.frames[cursor % kind.length] + " "
    }
  }
  
  mutating func reset() {
    cursor = 0
  }
  
  public enum Kind: CaseIterable {
    case box
    case matrix
    case bar
    case spin
    case circle
    case square
    case diamond
    case arrows
    case clock
    case globe
    
    fileprivate var frames: [String] {
      switch self {
        case .box:
          return [
            "⠋", "⠙",
            "⠹", "⠸",
            "⠼", "⠴",
            "⠦", "⠧",
            "⠇", "⠏"
          ]
        case .matrix:
          return [
            "⠋", "⠙",
            "⠚", "⠞",
            "⠖", "⠦",
            "⠴", "⠲",
            "⠳", "⠓"
          ]
        case .bar:
          return [
            "██▒▒▒▒▒▒▒▒",
            "▒▒██▒▒▒▒▒▒",
            "▒▒▒▒██▒▒▒▒",
            "▒▒▒▒▒▒██▒▒",
            "▒▒▒▒▒▒▒▒██",
            "▒▒▒▒▒▒██▒▒",
            "▒▒▒▒██▒▒▒▒",
            "▒▒██▒▒▒▒▒▒",
          ]
        case .spin:
          return ["|", "/", "-", "\\"]
        case .circle:
          return ["◴", "◷", "◶", "◵"]
        case .square:
          return ["◰", "◳", "◲", "◱"]
        case .diamond:
          return ["⬖", "⬘", "⬗", "⬙"]
        case .arrows:
          return ["←", "↖", "↑", "↗", "→", "↘", "↓", "↙"]
        case .clock:
          return ["🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛"]
        case .globe:
          return ["🌍", "🌎", "🌏"]
      }
    }
    
    fileprivate var length: Int {
      return self.frames.count
    }
  }
}
