import IdentifiedCollections
import Foundation
import Dependencies
import SwiftUI

class FavoritesViewModel: ObservableViewModel {
    struct State: Equatable {
        var allListings: IdentifiedArrayOf<Listing>
        var favoritesIds: [Listing.ID]
    }

    @Published private(set) var state: State

    private let favoritesModel: FavoritesModel

    init(favoritesModel: FavoritesModel, allListings: IdentifiedArrayOf<Listing>) {
        self.favoritesModel = favoritesModel
        self.state = .init(allListings: allListings, favoritesIds: favoritesModel.favorites)
    }

    var allListings: IdentifiedArrayOf<Listing> {
        get { state.allListings }
        set { state.allListings = newValue }
    }

    var favoritesIds: [Listing.ID] {
        get { state.favoritesIds }
        set { state.favoritesIds = newValue }
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
}
