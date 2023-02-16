import SwiftUI

struct PaymentCustomizationView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var paymentComponents: PropertyPaymentComponents

    func customizeDownPaymentView(_ viewModel: PaymentCustomizationViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Down Payment")
                    .font(.title3)
                TextField(
                    "Down Payment",
                    value: viewModel.binding(\.downPayment),
                    format: .number
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
                .onSubmit {
                    viewModel.updateDownPaymentPercentage()
                }
            }
            HStack {
                Text("Down Payment %")
                    .font(.title3)
                TextField(
                    "Down Payment %",
                    value: viewModel.binding(\.downPaymentPercentage),
                    format: .percent
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            }
            Slider(
                value: viewModel.binding(\.downPaymentPercentage),
                in: 0...1,
                step: 0.01,
                onEditingChanged: { _ in
                    viewModel.updateDownPayment()
                }
            )
            Divider()
            HStack {
                Text("Property Taxes")
                TextField(
                    "Property Taxes",
                    value: viewModel.binding(\.propertyTaxes),
                    format: .number
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            }
            Divider()
            HStack {
                Text("HOA Dues")
                TextField(
                    "HOA Dues",
                    value: viewModel.binding(\.hoaDues),
                    format: .number
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            }
            Divider()
            HStack {
                Text("% Interest Rate")
                TextField(
                    "% Interest Rate",
                    value: viewModel.binding(\.interestRate),
                    format: .number
                )
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            }
        }
        .padding(16)
    }

    var body: some View {
        WithViewModel(
            PaymentCustomizationViewModel(
                paymentComponents: paymentComponents
            )
        ) { viewModel in
            NavigationView {
                customizeDownPaymentView(viewModel)
                .padding(16)
                .navigationBarItems(
                    trailing:
                        Button("Save",
                        action: {
                            viewModel.save()
                        }
                    )
                )
            }
            .onChange(of: viewModel.dismiss) {
                if $0 { dismiss() }
            }
        }
        .bind(\.paymentComponents, to: $paymentComponents)
    }
}

struct PaymentCustomizationView_Previews: PreviewProvider {
    @State static var paymentComponents = PropertyPaymentComponents(
        price: 1000000,
        downPaymentPercentage: 0.2,
        hoaDues: 350,
        propertyTaxes: 1450,
        interestRate: 6.0,
        mortgageDuration: .thirty
    )

    static var previews: some View {
        PaymentCustomizationView(paymentComponents: $paymentComponents)
    }
}
