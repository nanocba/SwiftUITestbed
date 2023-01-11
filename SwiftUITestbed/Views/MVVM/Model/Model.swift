import Foundation

class Model: ObservableObject {
    @Published var count: Int = 0
    @Published var favoritePrimes: [Int] = []

    func toggleFavorite() {
        if isCurrentCountFavorite {
            removeFromFavorites()
        } else {
            saveToFavorites()
        }
    }

    func deleteFavoritePrime(_ offsets: IndexSet?) {
        guard let offsets = offsets else { return }
        favoritePrimes.remove(atOffsets: offsets)
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
