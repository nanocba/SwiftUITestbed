import SwiftUI

enum MortgageDuration: Int {
    case ten = 10
    case fifteen = 15
    case twenty = 20
    case thirty = 30
}

class PaymentSummaryViewModel: ObservableViewModel {
    @Published private(set) var state: State
    
    struct State: Equatable {
        var price: Double
        var mortgageDuration: MortgageDuration
        var annualInterest: Double
        var annualInterestText: String
        var propertyTaxes: Double
        var hoaDues: Double
        fileprivate var paymentPerMonth: Int
        fileprivate var principalAndInterest: Int

        init(
            price: Double,
            mortgageDuration: MortgageDuration,
            annualInterest: Double,
            propertyTaxes: Double,
            hoaDues: Double,
            paymentPerMonth: Int,
            principalAndInterest: Int
        ) {
            self.price = price
            self.mortgageDuration = mortgageDuration
            self.annualInterest = annualInterest
            self.annualInterestText = String(format: "%.2f", annualInterest)
            self.propertyTaxes = propertyTaxes
            self.hoaDues = hoaDues
            self.paymentPerMonth = paymentPerMonth
            self.principalAndInterest = principalAndInterest
        }
    }

    var paymentPerMonth: Int {
        get {
            return Int((Double(principalAndInterest) + state.hoaDues + state.propertyTaxes).rounded())
        }
        // Using an unecessary Set here - it's essentialy just a computed var. Is there a better way?
        set {
            state.paymentPerMonth = newValue
        }
    }

    var principalAndInterest: Int {
        get {
            let monthlyInterest = state.annualInterest / 100 / 12
            let numberOfPayments = Double(state.mortgageDuration.rawValue / 12)
            let num = (monthlyInterest * (1 + monthlyInterest) * numberOfPayments)
            let den = ((1 + monthlyInterest) * numberOfPayments + 1)
            return Int((state.price * num / den).rounded())
        }
        // Using an unecessary Set here - it's essentialy just a computed var. Is there a better way?
        set {
            state.principalAndInterest = newValue
        }
    }

    init(
        price: Double,
        propertyTaxes: Double = 0,
        hoaDues: Double = 0
    ) {
        self.state = State(
            price: price,
            mortgageDuration: .thirty,
            annualInterest: 6,
            propertyTaxes: propertyTaxes,
            hoaDues: hoaDues,
            paymentPerMonth: 0,
            principalAndInterest: 0
        )
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
