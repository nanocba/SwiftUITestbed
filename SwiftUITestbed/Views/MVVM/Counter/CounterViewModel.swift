import Foundation

class CounterViewModel: ObservableViewModel {
    struct State: Equatable {
        var count: Int = 0
        var favoritePrimes: [Int] = []
        var nthPrimeAlert: CounterState.PrimeAlert?
        var loading: Bool = false
        var primeModalShown: Bool = false
    }

    @Published var state: State = .init()

    func incr() {
        self.count += 1
    }

    func decr() {
        self.count -= 1
    }

    @MainActor func fetchNthPrime() async {
        self.loading = true
        defer { self.loading = false }
        guard let result = try? await wolframAlpha(query: "prime \(self.count)")?.primeResult else { return }
        self.nthPrimeAlert = .init(prime: result)
    }

    func presentPrimeModal() {
        self.primeModalShown = true
    }

    func toggleFavorite() {
        if isCurrentCountFavorite {
            removeFromFavorites()
        } else {
            saveToFavorites()
        }
    }

    var isPrime: Bool {
        if self.count <= 1 { return false }
        if self.count <= 3 { return true }
        for i in 2...Int(sqrtf(Float(self.count))) {
            if self.count % i == 0 { return false }
        }
        return true
    }

    var ordinal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: self.count) ?? ""
    }

    var favoriteActionTitle: String {
        isCurrentCountFavorite ? "Remove from favorites" : "Add to favorites"
    }

    var isCurrentCountFavorite: Bool {
        self.favoritePrimes.contains(self.count)
    }

    private func saveToFavorites() {
        self.favoritePrimes.append(self.count)
    }

    private func removeFromFavorites() {
        guard let index = self.favoritePrimes.firstIndex(of: self.count) else { return }
        self.favoritePrimes.remove(at: index)
    }
}
