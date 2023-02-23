import SwiftUI

class PaymentSummaryViewModel: ObservableViewModel {
    @Published private(set) var state: State
    
    struct State: Equatable {
        var paymentComponents: PropertyPaymentComponents
        var showingCustomCalculationSheet: Bool = false

        init(
            paymentComponents: PropertyPaymentComponents
        ) {
            self.paymentComponents = paymentComponents
        }
    }

    func presentCustomCalculation() {
        state.showingCustomCalculationSheet = true
    }

    var annualInterestText: String {
        String(format: "%.2f", state.paymentComponents.interestRate)
    }

    var paymentPerMonth: String {
        String(Int((Double(principalAndInterest) + state.paymentComponents.hoaDues + state.paymentComponents.propertyTaxes).rounded()))
    }

    private var principal: Double {
        state.paymentComponents.price * (1 - state.paymentComponents.downPaymentPercentage)
    }

    private var principalAndInterest: Int {
        let monthlyInterest = state.paymentComponents.interestRate / 100 / 12
        let numberOfPayments = Double(state.paymentComponents.mortgageDuration.rawValue / 12)
        let num = (monthlyInterest * (1 + monthlyInterest) * numberOfPayments)
        let den = ((1 + monthlyInterest) * numberOfPayments + 1)
        return Int((principal * num / den).rounded())
    }

    init(
        paymentComponents: PropertyPaymentComponents
    ) {
        self.state = State(
            paymentComponents: paymentComponents
        )
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
