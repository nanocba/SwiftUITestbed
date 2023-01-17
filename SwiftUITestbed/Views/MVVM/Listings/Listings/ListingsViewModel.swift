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
        self.state = .init(
            allListings: allListings,
            listings: allListings
        )
    }

    func setSearchTerm(_ value: String) {
        guard self.searchTerm != value else { return }
        Task(priority: .userInitiated) { @MainActor in
            try await self.performSearch(value)
        }
    }

    @MainActor func performSearch(_ value: String) async throws {
        print("setting \(value)")
        self.searchTerm = value

        searchTask?.cancel()

        let task = Task.detached {
            print("Task detacched")
            try await Task.sleep(for: .seconds(0.5))
            return try await self.search()
        }

        print("assigning task")
        searchTask = task
        self.listings = try await task.value
        print("assigning results")
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
        self.listings[id: id] = listing
    }

    func setAllListings(_ value: IdentifiedArrayOf<Listing>) {
        self.allListings = value
        for listing in value {
            self.setListing(id: listing.id, listing: listing)
        }
    }
}




