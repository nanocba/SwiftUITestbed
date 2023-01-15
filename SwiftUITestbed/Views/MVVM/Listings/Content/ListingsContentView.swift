import SwiftUI

struct ListingsContentView: View {
    var body: some View {
        WithViewModel(ListingsContentViewModel.init) { viewModel in
            TabView(selection: viewModel.binding(\.tab)) {
                ListingsView(allListings: viewModel.binding(\.allListings))
                    .tabItem {
                        Text("Listings")
                    }
                    .tag(ListingsContentViewModel.State.Tab.listings)

                FavoritesView(allListings: viewModel.binding(\.allListings))
                    .tabItem {
                        Text("Favorites")
                    }
                    .tag(ListingsContentViewModel.State.Tab.favorites)
            }
        }
    }
}
