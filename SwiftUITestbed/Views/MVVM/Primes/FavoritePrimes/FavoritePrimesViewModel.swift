import Foundation

class FavoritePrimesViewModel: ObservableObject {
    @Published var favoritePrimes: [Int] = []

    func deleteFavoritePrime(_ offsets: IndexSet?) {
        guard let offsets = offsets else { return }
        favoritePrimes.remove(atOffsets: offsets)
    }
}
