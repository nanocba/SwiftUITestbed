import IdentifiedCollections
import SwiftUI

struct ListingsView: View {
    @Binding var allListings: IdentifiedArrayOf<Listing>

    var body: some View {
        WithViewModel(ListingsViewModel(allListings: allListings)) { viewModel in
            NavigationView {
                List {
                    TextField(
                        "Search for listings",
                        text: viewModel.binding(\.searchTerm)
                    )
                    .loading(viewModel.searching)

                    ForEach(viewModel.state.listings) { listing in
                        ListingNavigationLink(listing: viewModel.binding(listing: listing))
                    }
                }
                .task {
                    await viewModel.fetchAllListings()
                }
                .navigationTitle("Listings")
                .overlay(alignment: .bottom) {
                    if let toast = viewModel.toast {
                        Text(toast)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .animation(.easeIn, value: viewModel.toast)
                            .transition(.move(edge: .bottom))
                            .task { await viewModel.hideToastAfter() }
                    }
                }
            }
        }
        .bind(\.allListings, to: $allListings)
    }
}
