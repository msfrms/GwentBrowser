//
//  ActionState.swift
//  Card browser
//
//  Created by Radaev Mikhail on 29/11/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

enum ActionState: Codable {

    enum CodingKeys: CodingKey {
        case type, value
    }

    enum CodingCase: String, Codable {
        case didLoadCardLinks, didSelectCard, didLoadCard, none
    }

    func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .didLoadCard(let card):
            try encoder.encode(CodingCase.didLoadCard, forKey: .type)
            try encoder.encode(card, forKey: .value)
        case .didLoadCardLinks(let links):
            try encoder.encode(CodingCase.didLoadCardLinks, forKey: .type)
            try encoder.encode(links, forKey: .value)
        case .didSelectCard(let card):
            try encoder.encode(CodingCase.didSelectCard, forKey: .type)
            try encoder.encode(card, forKey: .value)
        case .none:
            try encoder.encode(CodingCase.none, forKey: .type)
        }
    }

    init(action: Action) {
        switch action {
        case let action as DidLoadCard:
            self = .didLoadCard(action)
        case let action as DidSelectCard:
            self = .didSelectCard(action)
        case let action as DidLoadCardLinks:
            self = .didLoadCardLinks(action)
        default:
            self = .none
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(CodingCase.self, forKey: .type)

        switch value {
        case .didLoadCard:
            let card = try container.decode(DidLoadCard.self, forKey: .value)
            self = .didLoadCard(card)
        case .didLoadCardLinks:
            let cardlinks = try container.decode(DidLoadCardLinks.self, forKey: .value)
            self = .didLoadCardLinks(cardlinks)
        case .didSelectCard:
            let card = try container.decode(DidSelectCard.self, forKey: .value)
            self = .didSelectCard(card)
        case .none:
            self = .none
        }

    }

    case didLoadCardLinks(DidLoadCardLinks)
    case didSelectCard(DidSelectCard)
    case didLoadCard(DidLoadCard)
    case none

    static let initial = ActionState.none

    var title: String {
        switch self {
        case .didLoadCard:
            return "DidLoadCard"
        case .didLoadCardLinks:
            return "DidLoadCardLinks"
        case .didSelectCard:
            return "DidSelectCard"
        case .none:
            return "None"
        }
    }

    var action: Action? {
        switch self {
        case .didLoadCard(let loadCard):
            return loadCard
        case .didLoadCardLinks(let loadLinks):
            return loadLinks
        case .didSelectCard(let select):
            return select
        case .none:
            return nil
        }
    }
}

func reduce(_ state: ActionState, with action: Action) -> ActionState {
    switch action {
    case let action as DidLoadCardLinks:
        return .didLoadCardLinks(action)
    case let action as DidSelectCard:
        return .didSelectCard(action)
    case let action as DidLoadCard:
        return .didLoadCard(action)
    default:
        return .none
    }
}
