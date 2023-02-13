import SwiftUI

struct PaymentSummaryView: View {
    @State private var showingCustomCalculationSheet = false
    @Binding var listing: Listing

    fileprivate func customPayments() -> some View {
        return Button("Customize Payments") {
            showingCustomCalculationSheet.toggle()
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: $showingCustomCalculationSheet) {
            PaymentCustomizationView()
        }
    }

    fileprivate func paymentDetails(_ viewModel: PaymentSummaryViewModel) -> some View {
        return VStack(alignment: .leading, spacing: 8) {
            // Do I have to use wrapped value here
            Text("$\(viewModel.binding(\.paymentPerMonth).wrappedValue) per month")
            Text("$\(viewModel.binding(\.principalAndInterest).wrappedValue) per month")
            HStack {
                Text("\(viewModel.binding(\.mortgageDuration).wrappedValue.rawValue) Year Fixed, ")
                Text("\(viewModel.binding(\.annualInterestText).wrappedValue)% Interest")
            }
        }
        .padding(8)
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }

    var body: some View {
        WithViewModel(
            PaymentSummaryViewModel(
                price: listing.price,
                propertyTaxes: 1450,
                hoaDues: 350
            )
        ) { viewModel in
            paymentDetails(viewModel)
            customPayments()
        }
        .bind(\.price, to: $listing.price)
    }
}

struct PaymentSummaryView_Previews: PreviewProvider {
    @State static var listing = Listing(
        id: UUID(),
        title: "listing",
        address: Listing.Address(
            streetName: "123 Happy Lane",
            state: "New York",
            city: "NY",
            zipCode: "10024"),
        price: 1000000,
        parties: []
    )
    static var previews: some View {
        PaymentSummaryView(listing: $listing)
    }
}
