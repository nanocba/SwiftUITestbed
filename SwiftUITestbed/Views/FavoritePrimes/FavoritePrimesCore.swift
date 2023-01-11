import Foundation

struct FavoritePrimesState: Equatable {
    var favoritePrimes: [Int]
}

final class FavoritePrimesStore: Store<FavoritePrimesState> {
    func deleteFavoritePrime(_ offsets: IndexSet?) {
        guard let offsets = offsets else { return }
        self.favoritePrimes.remove(atOffsets: offsets)
    }
}
