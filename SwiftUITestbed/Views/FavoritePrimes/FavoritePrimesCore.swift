import Foundation

struct FavoritePrimesState: Equatable {
    var favoritePrimes: [Int]
}

final class FavoritePrimesStore: Store<FavoritePrimesState> {
    func deleteFavoritePrime(_ set: IndexSet?) {
        
    }
}
