import Foundation
import SwiftUI

struct CounterState: Equatable {
    var count: Int
    var favoritesPrimes: [Int]
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

    func saveToFavorites() {
        self.favoritesPrimes.append(self.count)
    }
}
