import SwiftUI

class FavoritesModel: ObservableObject {
    @Published private(set) var favorites: [Listing] = []

    func canAddAsFavorite(_ listing: Listing) -> Bool {
        listing.address.state == "California"
    }

    func toggle(_ listing: Listing) {
        if isFavorite(listing) {
            removeFromFavorites(listing)
        } else {
            addAsFavorite(listing)
        }
    }

    func isFavorite(_ listing: Listing) -> Bool {
        favorites.contains { $0.id == listing.id }
    }

    @discardableResult
    func addAsFavorite(_ listing: Listing) -> Bool {
        guard canAddAsFavorite(listing) else { return false }
        favorites.append(listing)
        return true
    }

    func removeFromFavorites(_ listing: Listing) {
        favorites.removeAll(where: { $0.id == listing.id })
    }
}
