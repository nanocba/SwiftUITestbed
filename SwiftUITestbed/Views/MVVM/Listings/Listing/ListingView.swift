import SwiftUI

struct ListingView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var listing: Listing

    @StateObject private var viewModel: EditListingViewModel

    // This init is intense
    init(listing: Binding<Listing>) {
        self._listing = listing
        self._viewModel = StateObject(wrappedValue: EditListingViewModel(listing: listing.wrappedValue))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("", text: $viewModel.title)
                .label("Title")

            TextField("", text: $viewModel.addressStreet)
                .label("Street")

            TextField("", text: $viewModel.addressCity)
                .label("City")

            TextField("", text: $viewModel.addressState)
                .label("State")

            TextField("", text: $viewModel.addressZipCode)
                .keyboardType(.numberPad)
                .label("Zip Code")

            TextField("", text: viewModel.binding(get: \.price, set: viewModel.updatePrice))
                .keyboardType(.numberPad)
                .label("Price")

            if let priceError = viewModel.error {
                Text(priceError)
                    .font(.callout)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .onChange(of: viewModel.dismiss) {
            if $0 { dismiss() }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", action: viewModel.cancel)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    FavoriteListingButton(listing)

                    Button("Save", action: viewModel.save)
                }
            }
        }
        .navigationTitle(viewModel.title)
        .alert(unwrapping: $viewModel.alert, action: viewModel.handleAlertAction)
        .bind($viewModel.source, to: $listing)
    }
}

