import IdentifiedCollections
import SwiftUI

struct ListingsView: View {
    @Binding var allListings: IdentifiedArrayOf<Listing>

    var body: some View {
        WithViewModel(ListingsViewModel.init, allListings) { viewModel in
            NavigationView {
                List {
                    TextField(
                        "Search for listings",
                        text: viewModel.binding(\.searchTerm)
                    )
                    .loading(viewModel.state.searching)

                    ForEach(viewModel.state.listings) { listing in
                        ListingNavigationLink(listing: viewModel.binding(listing: listing))
                    }
                }
                .task {
                    await viewModel.fetchAllListings()
                }
                .navigationTitle("Listings")
                .bind(model: viewModel.binding(\.allListings), to: $allListings)
            }
        }
    }
}
