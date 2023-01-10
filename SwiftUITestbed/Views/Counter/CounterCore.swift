import Foundation
import SwiftUI

@propertyWrapper struct MyCounterInt: DynamicProperty {
    var store: CounterStore!
    @State private var primeModalShown: Bool

    var wrappedValue: Bool {
        get {
            primeModalShown
        }
        nonmutating set {
            primeModalShown = newValue
        }
    }

    init(wrappedValue value: Bool) {
        self.primeModalShown = value
    }

    var projectedValue: Binding<Bool> {
        $primeModalShown
    }
}

struct CounterState: Equatable {
    var count: Int
    var isPrimeModalShown = false
    var nthPrimeAlert: PrimeAlert? = nil

    struct PrimeAlert: Identifiable, Equatable {
      let prime: Int
      var id: Int { self.prime }
    }
}

final class CounterStore: Store<CounterState>, DynamicProperty {
    func incr() {
        self.count += 1
    }

    func decr() {
        self.count -= 1
    }

    func presentPrimeModal() {
        self.isPrimeModalShown = true
    }
}
