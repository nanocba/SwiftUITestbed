import SwiftUI
import IdentifiedCollections

class ListingsViewModel: EventlessObservableViewModel {
    struct State: Equatable {
        fileprivate var searchTerm: String = ""
        var searching: Bool = false
        var loading: Bool = false
        fileprivate var allListings: IdentifiedArrayOf<Listing>
        var listings: IdentifiedArrayOf<Listing>
        var toast: String?
    }

    @Published private(set) var state: State

    var searchTask: Task<IdentifiedArrayOf<Listing>, Error>?

    deinit {
        unobserve()
    }

    init(allListings: IdentifiedArrayOf<Listing>) {
        state = .init(
            allListings: allListings,
            listings: allListings
        )

        observe(EditListingViewModel.self, closure: onListingViewModelEvent)
    }

    private func onListingViewModelEvent(event: EditListingViewModel.Event) {
        switch event {
        case .didSave:
            state.toast = "Listing saved"
        }
    }

    @MainActor
    func hideToastAfter() async {
        try? await Task.sleep(for: .seconds(1))
        state.toast = nil
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
        state.searchTerm = value

        searchTask?.cancel()

        let task = Task.detached {
            try await Task.sleep(for: .seconds(0.5))
            return try await self.search()
        }

        searchTask = task
        state.listings = try await task.value
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

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}




