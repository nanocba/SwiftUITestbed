import Foundation
import IdentifiedCollections

class ListingsContentViewModel: ObservableViewModel {
    struct State: Equatable {
        var tab: Tab
        var allListings: IdentifiedArrayOf<Listing>

        enum Tab: Equatable {
            case listings
            case favorites
        }
    }

    @Published private(set) var state: State = .init(tab: .listings, allListings: [])

    var tab: State.Tab {
        get { state.tab }
        set { state.tab = newValue }
    }

    var allListings: IdentifiedArrayOf<Listing> {
        get { state.allListings }
        set { state.allListings = newValue }
    }
}
