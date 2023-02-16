import SwiftUI

struct ListingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var listing: Listing

    fileprivate func paymentSummary(_ viewModel: EditListingViewModel) -> some View {
        HStack(alignment: .center) {
            Spacer()
            PaymentSummaryView(listing: viewModel.binding(\.source))
            Spacer()
        }
    }

    var body: some View {
        WithViewModel(EditListingViewModel(listing: listing)) { viewModel in
            VStack(alignment: .leading, spacing: 20) {
                TextField("", text: viewModel.binding(\.title))
                    .label("Title")

                TextField("", text: viewModel.binding(\.addressStreet))
                    .label("Street")

                TextField("", text: viewModel.binding(\.addressCity))
                    .label("City")

                TextField("", text: viewModel.binding(\.addressState))
                    .label("State")

                TextField("", text: viewModel.binding(\.addressZipCode))
                    .keyboardType(.numberPad)
                    .label("Zip Code")

                TextField("", text: viewModel.binding(\.price))
                    .keyboardType(.numberPad)
                    .label("Price")

                if let priceError = viewModel.error {
                    Text(priceError)
                        .font(.callout)
                        .foregroundColor(.red)
                }
                paymentSummary(viewModel)
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
            .alert(unwrapping: viewModel.binding(\.alert), action: viewModel.handleAlertAction)
        }
        .bind(\.source, to: $listing)
    }
}
