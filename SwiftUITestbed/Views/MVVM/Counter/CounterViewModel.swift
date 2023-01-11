import Foundation

class CounterViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var favoritePrimes: [Int] = []
    @Published var nthPrimeAlert: CounterState.PrimeAlert?
    @Published var loading: Bool = false
    @Published var primeModalShown: Bool = false

    func incr() {
        count += 1
    }

    func decr() {
        count -= 1
    }

    @MainActor func fetchNthPrime() async {
        loading = true
        defer { loading = false }
        guard let result = try? await wolframAlpha(query: "prime \(count)")?.primeResult else { return }
        nthPrimeAlert = .init(prime: result)
    }

    func presentPrimeModal() {
        primeModalShown = true
    }

    func toggleFavorite() {
        if isCurrentCountFavorite {
            removeFromFavorites()
        } else {
            saveToFavorites()
        }
    }

    var isPrime: Bool {
        if count <= 1 { return false }
        if count <= 3 { return true }
        for i in 2...Int(sqrtf(Float(count))) {
          if count % i == 0 { return false }
        }
        return true
    }

    var ordinal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: count) ?? ""
    }

    var favoriteActionTitle: String {
        isCurrentCountFavorite ? "Remove from favorites" : "Add to favorites"
    }

    var isCurrentCountFavorite: Bool {
        favoritePrimes.contains(count)
    }

    private func saveToFavorites() {
        favoritePrimes.append(count)
    }

    private func removeFromFavorites() {
        guard let index = favoritePrimes.firstIndex(of: count) else { return }
        favoritePrimes.remove(at: index)
    }
}
