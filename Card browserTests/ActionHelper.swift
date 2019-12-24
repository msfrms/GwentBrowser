//
//  ActionHelper.swift
//  Card browserTests
//
//  Created by Radaev Mikhail on 18/12/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation
@testable import Card_browser

struct ActionPayload: Codable {
    let payload: ActionState
}

func actionFrom(json: String) -> Action {
    do {
        let action = try JSONDecoder().decode(ActionState.self, from: json.data(using: .utf8)!)
        switch action {
        case .didLoadCard(let loadCard):
            return loadCard
        case .didLoadCardLinks(let loadLinks):
            return loadLinks
        case .didSelectCard(let select):
            return select
        case .none:
            fatalError()
        }
    } catch let error {
        print("error \(error)")
    }
    fatalError()
}

func stateFrom(json: String) -> State {
    guard json.count > 0 else { return State.initial }
    do {
        let state = try JSONDecoder().decode(State.self, from: json.data(using: .utf8)!)
        return state
    } catch let error {
        print("error \(error)")
    }
    fatalError()
}
