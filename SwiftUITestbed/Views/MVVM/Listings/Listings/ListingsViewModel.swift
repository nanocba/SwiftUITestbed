import SwiftUI
import IdentifiedCollections

class ListingsViewModel: ObservableViewModel {
    struct State: Equatable {
        var searchTerm: String = ""
        var searching: Bool = false
        var loading: Bool = false
        var allListings: IdentifiedArrayOf<Listing>
        var listings: IdentifiedArrayOf<Listing>
    }

    @Published var state: State

    var searchTask: Task<IdentifiedArrayOf<Listing>, Error>?

    init(allListings: IdentifiedArrayOf<Listing>) {
        self.state = .init(allListings: allListings, listings: allListings)
    }

    func setSearchTerm(_ value: String) {
        guard self.searchTerm != value else { return }
        
        self.searchTerm = value

        Task { @MainActor in
            searchTask?.cancel()

            let task = Task.detached {
                try await Task.sleep(for: .seconds(0.5))
                return try await self.search()
            }

            searchTask = task
            self.listings = try await task.value
        }
    }

    @MainActor func fetchAllListings() async {
        guard self.allListings.isEmpty else { return }
        self.loading = true
        try? await Task.sleep(for: .seconds(0.25))
        let listings: [Listing] = .all
        self.allListings = .init(uniqueElements: listings)
        self.listings = self.allListings
        self.loading = false
    }

    @MainActor func search() async throws -> IdentifiedArrayOf<Listing> {
        self.searching = true
        try await Task.sleep(for: .seconds(1))
        let term = self.searchTerm
        let listings = term.isEmpty ? self.allListings : self.allListings.filter { $0.listingTitle.contains(term) || $0.address.addressText.contains(term) }
        self.searching = false
        return .init(uniqueElements: listings)
    }

    func setListing(id: Listing.ID, listing: Listing) {
        self.allListings[id: id] = listing
    }
}




