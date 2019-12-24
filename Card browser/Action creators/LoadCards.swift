import Foundation

/// Simplest dispatchable type is prefferred
/// It is usually easier to test
func loadCards(url: URL, getURL: @escaping (URL) -> Future<CardsResponse> = getURL) -> Future<Action> {    
    return Future { complete in
        let action = DidLoadCardLinks(response: CardsResponse(
            next: nil,
            results: [
                CardLink(href: "", name: "CardLink1"),
                CardLink(href: "", name: "CardLink2"),
                CardLink(href: "", name: "CardLink3"),
                CardLink(href: "", name: "CardLink4"),
                CardLink(href: "", name: "CardLink5"),
            ]))
        complete(action)
    }
}

