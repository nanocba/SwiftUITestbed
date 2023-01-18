import IdentifiedCollections
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesModel: FavoritesModel
    @Binding var allListings: IdentifiedArrayOf<Listing>

    var body: some View {
        WithViewModel(FavoritesViewModel.init, favoritesModel, allListings) { viewModel in
            NavigationStack {
                List {
                    ForEach(viewModel.favorites) { favoriteListing in
                        ListingNavigationLink(listing: viewModel.binding(listing: favoriteListing))
                    }
                }
                .navigationTitle("Favorites")
                .bind(model: viewModel.binding(\.allListings), to: $allListings)
                .bind(model: viewModel.binding(\.favoritesIds), to: favoritesModel.favorites)
            }
        }
    }
}
