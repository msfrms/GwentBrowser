//
//  DevToolsSender.swift
//  Card browser
//
//  Created by Radaev Mikhail on 23/12/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

public enum MonitorCommand<State: Codable> {
    case action(State)
    case rollback(State)
}

public class DevToolsSender {

    public func send<A: Codable, S: Codable>(action: ActionMonitor<A, S>) {}
    public func observe(command: (String) -> Void) {
        
    }
}
