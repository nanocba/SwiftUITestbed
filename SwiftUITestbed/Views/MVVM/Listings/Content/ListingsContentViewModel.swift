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

    @Published var state: State = .init(tab: .listings, allListings: [])
}
