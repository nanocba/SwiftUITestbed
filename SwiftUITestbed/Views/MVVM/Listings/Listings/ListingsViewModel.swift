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

    @Published private(set) var state: State

    var searchTask: Task<IdentifiedArrayOf<Listing>, Error>?

    init(allListings: IdentifiedArrayOf<Listing>) {
        state = .init(
            allListings: allListings,
            listings: allListings
        )
    }

    var searchTerm: String {
        get { state.searchTerm }
        set {
            guard state.searchTerm != newValue else { return }
            Task(priority: .userInitiated) { @MainActor in
                try await self.performSearch(newValue)
            }
        }
    }

    var allListings: IdentifiedArrayOf<Listing> {
        get { state.allListings }
        set {
            state.allListings = newValue
            for listing in newValue {
                self.updateListing(listing)
            }
        }
    }

    func binding(listing: Listing) -> Binding<Listing> {
        Binding(
            get: { listing },
            set: { self.updateListing($0) }
        )
    }

    private func updateListing(_ listing: Listing) {
        self.state.allListings[id: listing.id] = listing
        self.state.listings[id: listing.id] = listing
    }

    @MainActor func performSearch(_ value: String) async throws {
        print("setting \(value)")
        state.searchTerm = value

        searchTask?.cancel()

        let task = Task.detached {
            print("Task detacched")
            try await Task.sleep(for: .seconds(0.5))
            return try await self.search()
        }

        print("assigning task")
        searchTask = task
        state.listings = try await task.value
        print("assigning results")
    }

    @MainActor func fetchAllListings() async {
        guard state.allListings.isEmpty else { return }
        state.loading = true
        try? await Task.sleep(for: .seconds(0.25))
        let listings: [Listing] = .all
        state.allListings = .init(uniqueElements: listings)
        state.listings = state.allListings
        state.loading = false
    }

    @MainActor func search() async throws -> IdentifiedArrayOf<Listing> {
        state.searching = true
        try await Task.sleep(for: .seconds(1))
        let term = state.searchTerm
        let listings = term.isEmpty ? state.allListings : state.allListings.filter { $0.listingTitle.contains(term) || $0.address.addressText.contains(term) }
        state.searching = false
        return .init(uniqueElements: listings)
    }
}




