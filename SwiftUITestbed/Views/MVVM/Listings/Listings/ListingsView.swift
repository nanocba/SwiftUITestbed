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
                        text: viewModel.binding(
                            get: \.searchTerm,
                            set: viewModel.setSearchTerm
                        )
                    )
                    .loading(viewModel.searching)

                    ForEach(viewModel.listings) { listing in
                        ListingNavigationLink(
                            listing: viewModel.binding(
                                get: listing,
                                set: viewModel.setListing)
                        )
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
