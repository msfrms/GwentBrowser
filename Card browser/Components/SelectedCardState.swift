import Foundation

/// Component state can be modelled as enum as well as struct
enum SelectedCardState: Codable, Equatable {
    static func == (lhs: SelectedCardState, rhs: SelectedCardState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        default:
            return false
        }

    }


    enum CodingKeys: CodingKey {
        case type, value
    }

    enum CodingCase: String, Codable {
        case none, loading, loaded
    }

    func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .none:
            try encoder.encode(CodingCase.none, forKey: .type)
        case .loading(let link):
            try encoder.encode(CodingCase.loading, forKey: .type)
            try encoder.encode(link, forKey: .value)
        case .loaded(let card):
            try encoder.encode(CodingCase.loaded, forKey: .type)
            try encoder.encode(card, forKey: .value)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(CodingCase.self, forKey: .type)

        switch value {
        case .none:
            self = .none
        case .loading:
            let cardlink = try container.decode(CardLink.self, forKey: .value)
            self = .loading(cardlink)
        case .loaded:
            let card = try container.decode(Card.self, forKey: .value)
            self = .loaded(card)
        }

    }

    case none
    case loading(CardLink)
    case loaded(Card)
    
    static let initial = SelectedCardState.none
}

func reduce(_ state: SelectedCardState, with action: Action) -> SelectedCardState {
    switch action {
    case let action as DidSelectCard: return .loading(action.link)
    case let action as DidLoadCard: return .loaded(action.card)
    default: return state }
}
