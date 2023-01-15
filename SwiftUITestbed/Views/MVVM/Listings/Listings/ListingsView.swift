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

struct ListingNavigationLink: View {
    @Binding var listing: Listing

    var body: some View {
        NavigationLink(destination: ListingView(listing: $listing)) {
            VStack(alignment: .leading) {
                HStack {
                    Text(listing.listingTitle)
                        .font(.body)

                    FavoriteListingButton(listing)
                }

                Text(listing.address.addressText)
                   .font(.callout)
                   .foregroundColor(.gray)
            }
        }
    }
}

struct LabelViewModifier: ViewModifier {
    let label: String

    func body(content: LabelViewModifier.Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.callout)
                .foregroundColor(.gray)

            content
                .font(.body)
        }
    }
}

extension View {
    func label(_ label: String) -> some View {
        modifier(LabelViewModifier(label: label))
    }
}

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
