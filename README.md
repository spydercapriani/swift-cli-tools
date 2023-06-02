# swift-cli-tools

Console Command Line Interface Helpers

## ConsoleUI

Contains helper extensions for [TerminalController](https://github.com/apple/swift-tools-support-core/blob/main/Sources/TSCBasic/TerminalController.swift) to aid in common command line ui tasks.

```swift
console.action("Action Title")
# Outputs:
# 🔵 [action]	Action Title
# ---------------------------------------------------------------

console.bot("Hello there!")
# Outputs:
# [◕ ◡ ◕] - Hello there!

console.step("Step Example")
# Outputs:
# ⇒ Step Example

console.info("Information goes here")
# Outputs:
# 🔷 [info] Information goes here

console.warn("Issue warning")
# Outputs:
# ⚠️ [warning] Issue warning

console.error("Danger Will Robinson!")
# Outputs:
# ❌ [error] Danger Will Robinson!

console.success("Congratulations!")
# Outputs:
# ✅ [success] Congratulations!

console.wait()
# Outputs:
# [◕ ◡ ◕] - Press any key to continue...

console.confirm("Would you like to continue?") ? console.setTable() : console.flipTable()
# Outputs:
# [◕ ◡ ◕] - Would you like to continue?
# (Y)es | (N)o

let username = console.prompt("Username")
# Outputs:
# [◕ ◡ ◕] - Username: <Input text visible>

# Secure Entry Prompt
let password = console.prompt("Password", isSecure: true)
# Outputs:
# [◕ ◡ ◕] - Password: <Input text hidden>
```

See [Demo](./Sources/Demo/Demo.swift) for more examples.

[◕ ◡ ◕] - Good Luck out there!
