import Foundation

struct AppState: Equatable {
    var count: Int = 0
    var favoritePrimes: [Int] = []

    var counterState: CounterState {
        get {
            .init(
                count: count
            )
        }
        set {
            self.count = newValue.count
        }
    }

    var favoritePrimesState: FavoritePrimesState {
        get {
            .init(
                favoritePrimes: favoritePrimes
            )
        }
        set {
            self.favoritePrimes = newValue.favoritePrimes
        }
    }
}
