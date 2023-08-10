//
//  Consoles.swift
//  
//
//  Created by Danny Gilbert on 6/2/23.
//

import TSCBasic

public let console = TerminalController(stream: stdoutStream)!
public let errorConsole = TerminalController(stream: stderrStream)!
