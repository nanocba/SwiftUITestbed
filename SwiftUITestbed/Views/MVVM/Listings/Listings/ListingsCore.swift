import SwiftUI
import IdentifiedCollections

class ListingsViewModel: ObservableViewModel {
    struct State: Equatable {
        var searchTerm: String = ""
        var loading: Bool = false
        var allListings: IdentifiedArrayOf<Listing> = []

        var listings: IdentifiedArrayOf<Listing> {
            let term = searchTerm
            let listings = term.isEmpty ? self.allListings : self.allListings.filter { $0.listingTitle.contains(term) || $0.address.addressText.contains(term) }
            return .init(uniqueElements: listings)
        }
    }

    @Published var state: State = .init()

    @MainActor func fetchAllListings() async {
        guard self.allListings.isEmpty else { return }
        self.loading = true
        try? await Task.sleep(for: .seconds(0.25))
        let listings: [Listing] = .all
        self.allListings = .init(uniqueElements: listings)
        self.loading = false
    }

    func setListing(id: Listing.ID, listing: Listing) {
        self.allListings[id: id] = listing
    }
}




