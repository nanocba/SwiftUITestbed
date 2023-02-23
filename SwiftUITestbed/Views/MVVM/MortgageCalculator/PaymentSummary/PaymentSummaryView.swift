import SwiftUI

struct PaymentSummaryView: View {
    @Binding var listing: Listing

    var body: some View {
        WithViewModel(
            PaymentSummaryViewModel(
                paymentComponents:
                    PropertyPaymentComponents(
                        price: listing.price,
                        downPaymentPercentage: 0.2,
                        hoaDues: 350,
                        propertyTaxes: 1450,
                        interestRate: 6.0,
                        mortgageDuration: .thirty
                    )
                )
            ) { viewModel in
            paymentDetails(viewModel)
            customPayments(viewModel)
        }
        .bind(\.paymentComponents.price, to: $listing.price)
    }

    fileprivate func customPayments(_ viewModel: PaymentSummaryViewModel) -> some View {
        Button("Customize Payments") {
            viewModel.presentCustomCalculation()
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: viewModel.binding(\.showingCustomCalculationSheet)) {
            PaymentCustomizationView(
                paymentComponents: viewModel.binding(\.paymentComponents)
            )
        }
    }

    fileprivate func paymentDetails(_ viewModel: PaymentSummaryViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Do I have to use wrapped value here
            Text("$\(viewModel.paymentPerMonth) per month")
            HStack {
                Text("\(viewModel.paymentComponents.mortgageDuration.rawValue) Year Fixed, ")
                Text("\(viewModel.annualInterestText)% Interest")
            }
        }
        .padding(8)
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
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
