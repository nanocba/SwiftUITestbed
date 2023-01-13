import SwiftUI

struct ListingsContentView: View {
    @StateObject private var viewModel = ListingsContentViewModel()

    var body: some View {
        TabView(selection: $viewModel.tab) {
            ListingsView(allListings: $viewModel.allListings)
                .tabItem {
                    Text("Listings")
                }
                .tag(ListingsContentViewModel.State.Tab.listings)

            FavoritesView(allListings: $viewModel.allListings)
                .tabItem {
                    Text("Favorites")
                }
                .tag(ListingsContentViewModel.State.Tab.favorites)
        }
    }
}
