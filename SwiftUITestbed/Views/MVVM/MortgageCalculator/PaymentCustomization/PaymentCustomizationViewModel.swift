import SwiftUI

class PaymentCustomizationViewModel: ObservableViewModel {
    @Published private(set) var state: State

    struct State: Equatable {
        var downPayment: Double
        var downPaymentPercentage: Double
        var propertyTaxes: Double
        var hoaDues: Double
        var interestRate: Double
        var mortgageDuration: MortgageDuration
        var dismiss: Bool

        fileprivate var price: Double
        fileprivate var paymentComponents: PropertyPaymentComponents

        init(paymentComponents: PropertyPaymentComponents) {
            self.downPayment = paymentComponents.price * paymentComponents.downPaymentPercentage
            self.downPaymentPercentage = paymentComponents.downPaymentPercentage
            self.propertyTaxes = paymentComponents.propertyTaxes
            self.hoaDues = paymentComponents.hoaDues
            self.interestRate = paymentComponents.interestRate
            self.mortgageDuration = paymentComponents.mortgageDuration
            self.price = paymentComponents.price
            self.paymentComponents = paymentComponents
            self.dismiss = false
        }
    }

    init(
        paymentComponents: PropertyPaymentComponents
    ) {
        self.state = State(
            paymentComponents: paymentComponents
        )
    }

    var paymentComponents: PropertyPaymentComponents {
        get {
            state.paymentComponents
        }
        set {
            state.paymentComponents = newValue
        }
    }

    func save() {
        state.paymentComponents = PropertyPaymentComponents(
            price: state.price,
            downPaymentPercentage: state.downPaymentPercentage,
            hoaDues: state.hoaDues,
            propertyTaxes: state.propertyTaxes,
            interestRate: state.interestRate,
            mortgageDuration: state.mortgageDuration
        )
        state.dismiss = true
    }

    func updateDownPayment() {
        state.downPayment = state.price * state.downPaymentPercentage
    }

    func updateDownPaymentPercentage() {
        state.downPaymentPercentage = Double(state.downPayment / state.price) * 100 / 100
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
