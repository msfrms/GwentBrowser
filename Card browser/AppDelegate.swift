import UIKit
import MonitorDevToolsSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let monitor = Monitor(url: "ws://localhost:8000/socketcluster/", clientId: "card_browser_ios_client", ssl: false)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let store = Store(state: State.initial, reducer: reduce, middleware: { [unowned self] state, action, _ in
            let actionWrap = ActionState(action: action)
            let actionMonitor = DevToolsAction<ActionState, State>(
                title: actionWrap.title,
                action: actionWrap,
                state: state
            )

            self.monitor.send(action: actionMonitor)
        })
        let navigation = window?.rootViewController as! UINavigationController
        let vc = navigation.viewControllers.first as! CardListViewController
        
        /// Connect initial controller to application store.
        vc.connect(to: store)

        monitor.onConnected = {
            let url = URL(string: "https://api.gwentapi.com/v0/cards")!
            store.dispatch(future: loadCards(url: url))
        }

        monitor.observe { dispatch in
            switch dispatch {

            case .jumpToAction(let jsonState):
                let state = try! JSONDecoder().decode(State.self, from: jsonState.data(using: .utf8)!)
                store.setState(state)

            case .jumpToState(let jsonState):
                let state = try! JSONDecoder().decode(State.self, from: jsonState.data(using: .utf8)!)
                store.setState(state)

            case .action(let payload):
                func dispatchAction(_ action: ActionState) {
                    switch action {
                    case .didLoadCard(let loadCard):
                        store.dispatch(action: loadCard)
                    case .didLoadCardLinks(let loadLinks):
                        store.dispatch(action: loadLinks)
                    case .didSelectCard(let select):
                        store.dispatch(action: select)
                    case .none: ()
                    }
                }
                let action = try! JSONDecoder().decode(ActionState.self, from: payload.data(using: .utf8)!)
                dispatchAction(action)

            default:
                break
            }
        }

        monitor.connect()

        return true
    }
}

extension CardListViewController {
    /// Each UI element is generic and need explicit connection points
    func connect(to store: Store<State>) {
        
        /// Hellper function for mapping each cardlink into card props.
        func cardProps(from link: CardLink) -> Props.Card {
            
            /// This command will be performad whenever cell is selected and
            /// controller is already presented
            let select = CommandWith<UIViewController> { vc in
                
                /// We need to make sure that controller of correct kind is presented.
                /// Please note: CardList itself doesnot know the type of presented controller.
                guard let cardDetails = vc as? CardDetailsViewController else {
                    fatalError("Cannot handle selected vc: \(vc)")
                }
                
                /// Title need to be updated specifically, becouse this is the only point
                /// when UIKit will render it before animation
                vc.title = link.name
                
                /// Performing of actual business logic
                store.dispatch(command: selectCard(link: link))
                
                /// Connecting controller to store.
                cardDetails.connect(to: store)
            }
            
            return Props.Card(name: link.name, select: select)
        }
        
        /// State observer which will update vc props every time whene
        let observer = CommandWith<State>(id: "List vc observer for \(self)") { state in
            let cards: [Props.Card] = state.cardList.links.map(cardProps)
            
            /// Existence of this command is bound to existance of next url.
            let loadMore: Command? = state.cardList.nextPageURL.map { url in
                Command(id: "load more cards from \(url)") {
                    loadCards(url: url).onComplete(perform: store.dispatch)
                }
            }
            
            self.props = Props(
                cards: cards,
                onLastCellDisplayed: loadMore)
        }
        
        /// Connecting observer to store.
        /// Please note: Execution is tied to main thread.
        store.observe(with: observer.dispatched(on: .main))
    }
}


/// Same pattern applied in this controller
extension CardDetailsViewController {
    func connect(to store: Store<State>) {
        /// Command to stop observation.
        /// We need to call it when view controller is destroyed
        var cancelObserving: Command?
        
        // [weak self] is a way to avoid cycles.
        let observer = CommandWith<State>(id: "Card details observer for \(self)") { [weak self] state in
            switch state.selectedCard {
            case .none: self?.props = Props.initial
            case .loading(let link): self?.props = Props(
                name: link.name,
                onDestroy: cancelObserving,
                state: .loading)
            case .loaded(let card): self?.props = Props(
                name: card.name,
                onDestroy: cancelObserving,
                state: .card(Props.Card(
                    flavor: card.flavor,
                    power: card.strength.map(String.init) ?? "Unspecified",
                    description: card.info ?? "None")))
            }
        }
        
        cancelObserving = store.observe(with: observer.dispatched(on: .main))
    }
}
