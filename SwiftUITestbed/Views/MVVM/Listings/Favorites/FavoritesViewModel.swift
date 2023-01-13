import IdentifiedCollections
import Foundation
import Dependencies

class FavoritesViewModel: ObservableViewModel {
    struct State: Equatable {
        var allListings: IdentifiedArrayOf<Listing>
        var favoritesIds: [Listing.ID]
    }

    @Published var state: State

    let favoritesModel: FavoritesModel

    init(favoritesModel: FavoritesModel, allListings: IdentifiedArrayOf<Listing>) {
        self.favoritesModel = favoritesModel
        self.state = .init(allListings: allListings, favoritesIds: favoritesModel.favorites)
    }

    func setListing(_ id: Listing.ID, listing: Listing) {
        self.allListings[id: id] = listing
    }

    var favorites: IdentifiedArrayOf<Listing> {
        favoritesModel.favoritesListings(self.allListings)
    }
}
