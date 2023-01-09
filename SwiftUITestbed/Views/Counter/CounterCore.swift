import Foundation

struct CounterState: Equatable {
    var count: Int
    var isPrimeModalShown = false
    var nthPrimeAlert: PrimeAlert? = nil

    struct PrimeAlert: Identifiable, Equatable {
      let prime: Int
      var id: Int { self.prime }
    }
}

final class CounterStore: Store<CounterState> {
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
