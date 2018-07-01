//
//  Shell-StaggaredCommandExecuter.swift
//  Shell
//
//  Created by Jeremy Bannister on 6/30/18.
//  Copyright © 2018 Jeremy Bannister. All rights reserved.
//

import Foundation

// MARK: - Initial Declaration
extension Shell {
  internal class StaggaredCommandExecuter {
    private(set) var commandsAndStaggarDurations: [(command: Command, staggarDuration: TimeInterval)] = []
    private(set) var isExecuting = false
  }
}

// MARK: - Exposed API
extension Shell.StaggaredCommandExecuter {
  func queueCommand (_ command: Shell.Command, staggarDuration: TimeInterval) {
    commandsAndStaggarDurations.append((command, staggarDuration))
    if !isExecuting { executeNext() }
  }
  
  func queueCommand (_ commandPath: String, _ commandArguments: [String], staggarDuration: TimeInterval) {
    queueCommand(Shell.Command(path: commandPath, arguments: commandArguments), staggarDuration: staggarDuration)
  }
}

// MARK: - Private
private extension Shell.StaggaredCommandExecuter {
  func executeNext () {
    guard let next = commandsAndStaggarDurations.first else {
      isExecuting = false
      return
    }
    isExecuting = true
    commandsAndStaggarDurations.remove(at: 0)
    DispatchQueue.main.asyncAfter(deadline: .now() + next.staggarDuration) {
      Shell.execute(next.command)
      self.executeNext()
    }
  }
}
