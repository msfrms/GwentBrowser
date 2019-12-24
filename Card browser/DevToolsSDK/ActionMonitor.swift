//
//  Action.swift
//  Card browser
//
//  Created by Radaev Mikhail on 30/11/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

public struct ActionMonitor<A: Codable, S: Codable> {
    public let title: String
    public let action: A
    public let state: S
}

extension ActionMonitor {

    var toDictionary: [String: Any] {
        let encoder = JSONEncoder()
        let state = (try? encoder.encode(self.state)).flatMap { String(data: $0, encoding: .utf8) }
        let action = (try? encoder.encode(self.action)).flatMap { String(data: $0, encoding: .utf8) }
        return [
            "type": MonitorTypes.action.rawValue,
            "action": [
                "type": title,
                "payload": action ?? MonitorTypes.undefined.rawValue
            ],
            "payload": state ?? MonitorTypes.undefined.rawValue,
        ]
    }
}
