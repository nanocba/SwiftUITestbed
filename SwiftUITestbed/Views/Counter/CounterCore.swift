import Foundation
import SwiftUI

struct CounterState: Equatable {
    var count: Int
    var favoritesPrimes: [Int]
    var isPrimeModalShown = false
    var nthPrimeAlert: PrimeAlert? = nil
    var loading: Bool = false

    var isFavorite: Bool {
        favoritesPrimes.contains(count)
    }

    struct PrimeAlert: Identifiable, Equatable {
      let prime: Int
      var id: Int { self.prime }
    }
}

@MainActor
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

    func toggleFavorite() {
        if self.isFavorite {
            removeFromFavorites()
        } else {
            saveToFavorites()
        }
    }

    func fetchNthPrime() async {
        self.loading = true
        defer { self.loading = false }
        guard let result = try? await wolframAlpha(query: "prime \(self.count)")?.primeResult else { return }
        self.nthPrimeAlert = .init(prime: result)
    }

    private func saveToFavorites() {
        self.favoritesPrimes.append(self.count)
    }

    private func removeFromFavorites() {
        guard let index = self.favoritesPrimes.firstIndex(of: self.count) else { return }
        self.favoritesPrimes.remove(at: index)
    }
}
