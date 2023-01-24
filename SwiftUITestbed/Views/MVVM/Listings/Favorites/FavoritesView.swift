import IdentifiedCollections
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesModel: FavoritesModel
    @Binding var allListings: IdentifiedArrayOf<Listing>

    var body: some View {
        WithViewModel(FavoritesViewModel(favoritesModel: favoritesModel, allListings: allListings)) { viewModel in
            NavigationStack {
                List {
                    ForEach(viewModel.favorites) { favoriteListing in
                        ListingNavigationLink(listing: viewModel.binding(listing: favoriteListing))
                    }
                }
                .navigationTitle("Favorites")
            }
        }
        .bind(\.allListings, to: $allListings)
        .bind(\.favoritesIds, to: favoritesModel.favorites)
    }
}
