import Foundation

enum MortgageDuration: Int {
    case ten = 10
    case fifteen = 15
    case twenty = 20
    case thirty = 30
}

struct PropertyPaymentComponents: Equatable {
    var price: Double
    var downPaymentPercentage: Double
    var hoaDues: Double
    var propertyTaxes: Double
    var interestRate: Double
    var mortgageDuration: MortgageDuration
}
