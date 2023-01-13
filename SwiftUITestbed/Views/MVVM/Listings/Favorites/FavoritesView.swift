import IdentifiedCollections
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesModel: FavoritesModel
    @Binding var allListings: IdentifiedArrayOf<Listing>

    var body: some View {
        NavigationStack {
            _FavoritesView(
                favoritesModel: favoritesModel,
                allListings: $allListings
            )
        }
    }

    struct _FavoritesView: View {
        @ObservedObject var favoritesModel: FavoritesModel
        @Binding var allListings: IdentifiedArrayOf<Listing>
        @StateObject private var viewModel: FavoritesViewModel

        init(favoritesModel: FavoritesModel, allListings: Binding<IdentifiedArrayOf<Listing>>) {
            self.favoritesModel = favoritesModel
            self._allListings = allListings
            self._viewModel = StateObject(
                wrappedValue: .init(
                    favoritesModel: favoritesModel,
                    allListings: allListings.wrappedValue
                )
            )
        }

        var body: some View {
            List {
                ForEach(viewModel.favorites) { favoriteListing in
                    ListingNavigationLink(
                        listing: viewModel.binding(
                            get: favoriteListing,
                            set: viewModel.setListing)
                    )
                }
            }
            .navigationTitle("Favorites")
            .bind(model: $viewModel.allListings, to: $allListings)
            .bind(model: $viewModel.favoritesIds, to: favoritesModel.favorites)
        }
    }
}
