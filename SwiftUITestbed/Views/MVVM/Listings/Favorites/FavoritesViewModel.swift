import IdentifiedCollections
import Foundation
import Dependencies
import SwiftUI

class FavoritesViewModel: ObservableViewModel {
    struct State: Equatable {
        fileprivate var allListings: IdentifiedArrayOf<Listing>
        fileprivate var favoritesIds: [Listing.ID]
    }

    @Published private(set) var state: State

    private let favoritesModel: FavoritesModel

    init(favoritesModel: FavoritesModel, allListings: IdentifiedArrayOf<Listing>) {
        self.favoritesModel = favoritesModel
        self.state = .init(allListings: allListings, favoritesIds: favoritesModel.favorites)
    }

    func binding(listing: Listing) -> Binding<Listing> {
        Binding(
            get: { listing },
            set: { self.state.allListings[id: listing.id] = $0 }
        )
    }

    var favorites: IdentifiedArrayOf<Listing> {
        favoritesModel.favoritesListings(state.allListings)
    }

    var favoritesIds: [Listing.ID] {
        get { state.favoritesIds }
        set { state.favoritesIds = newValue }
    }

    var allListings: IdentifiedArrayOf<Listing> {
        get { state.allListings }
        set { state.allListings = newValue }
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
