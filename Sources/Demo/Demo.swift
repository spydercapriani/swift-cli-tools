//
//  Demo.swift
//  
//
//  Created by Danny Gilbert on 6/1/23.
//

import Foundation
import ConsoleUI
import TSCBasic

@main
struct Demo {
  
  static func main() throws {
    console.action("Action Title")
    console.bot("Hello there!")
    console.step("Step Example")
    console.info("Information goes here")
    console.warn("Issue warning")
    console.error("Danger Will Robinson!")
    console.success("Congratulations!")
    console.wait()
    console.confirm("Would you like to continue?") ? console.setTable() : console.flipTable()
    let username = console.prompt("Username")
    console.print("You entered \(username)", inColor: .yellow)
    let password = console.prompt("Password", isSecure: true)
    console.print("You entered \(password)", inColor: .yellow)
    
    let spinnable = createProgressSpinner(
      forStream: stdoutStream,
      started: "Task In Progress...",
      finished: "✅ Completed Task",
      spinner: Spinner(kind: .matrix)
    )
    spinnable.start()
    let seconds = useconds_t(Double(3) * pow(1000, 2))
    usleep(seconds)
    spinnable.stop()
  }
}
