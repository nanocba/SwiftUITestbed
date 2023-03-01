import SwiftUI

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
