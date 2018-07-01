//
//  Shell.swift
//  Shell
//
//  Created by Jeremy Bannister on 6/30/18.
//  Copyright © 2018 Jeremy Bannister. All rights reserved.
//

import Foundation

// MARK: - Initial Declaration
public class Shell {
  private let staggaredCommandExecuter = StaggaredCommandExecuter()
  private var defaultStaggarDelay: TimeInterval
  
  public init (defaultStaggarDelay: TimeInterval = 0.1) {
    self.defaultStaggarDelay = defaultStaggarDelay
  }
}

// MARK: - Public API
extension Shell {
  public func staggarExecution (path: String, arguments: [String] = [], staggarDuration: TimeInterval? = nil) {
    staggaredCommandExecuter.queueCommand(path, arguments, staggarDuration: staggarDuration ?? defaultStaggarDelay)
  }
  
  public static func execute (path: String, arguments: [String] = []) {
    Shell.execute(Command(path: path, arguments: arguments))
  }
}

// MARK: - Execution
extension Shell {
  static func execute (_ command: Command) {
    let process = Process.launchedProcess(launchPath: command.path, arguments: command.arguments)
    process.waitUntilExit()
  }
}
