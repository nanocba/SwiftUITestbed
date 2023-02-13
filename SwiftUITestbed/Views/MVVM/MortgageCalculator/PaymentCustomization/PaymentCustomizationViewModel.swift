import SwiftUI

class PaymentCustomizationViewModel: ObservableViewModel {
    @Published private(set) var state: State

    struct State: Equatable {
//        var downPayment: Double
//        var downPaymentPercentage: Double
//        var propertyTaxes: Double
//        var hoaDues: Double
//        var interestRate: Double
//        var mortgageDuration: MortgageDuration
    }

    init() {
        self.state = State()
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
