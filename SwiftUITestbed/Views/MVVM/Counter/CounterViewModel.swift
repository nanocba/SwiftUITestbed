import Foundation

class CounterViewModel: ObservableObject {
    @Published var nthPrimeAlert: CounterState.PrimeAlert?
    @Published var loading: Bool = false
    @Published var primeModalShown: Bool = false

    @MainActor func fetchNthPrime(_ count: Int) async {
        loading = true
        defer { loading = false }
        guard let result = try? await wolframAlpha(query: "prime \(count)")?.primeResult else { return }
        nthPrimeAlert = .init(prime: result)
    }

    func presentPrimeModal() {
        primeModalShown = true
    }

    func favoriteActionTitle(isFavorite: Bool) -> String {
        isFavorite ? "Remove from favorites" : "Add to favorites"
    }

    func isPrime(_ count: Int) -> Bool {
        if count <= 1 { return false }
        if count <= 3 { return true }
        for i in 2...Int(sqrtf(Float(count))) {
          if count % i == 0 { return false }
        }
        return true
    }

    func ordinal(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: n) ?? ""
    }
}
