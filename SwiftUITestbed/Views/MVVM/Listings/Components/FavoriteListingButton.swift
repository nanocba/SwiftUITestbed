import SwiftUI

struct FavoriteListingButton: View {
    @EnvironmentObject var favoritesModel: FavoritesModel
    let listing: Listing

    init(_ listing: Listing) {
        self.listing = listing
    }

    var body: some View {
        if favoritesModel.canAddAsFavorite(listing) {
            Image(systemName: favoritesModel.isFavorite(listing) ? "heart.fill" : "heart")
                .onTapGesture { favoritesModel.toggle(listing) }
                .foregroundColor(.blue)
        }
    }
}
