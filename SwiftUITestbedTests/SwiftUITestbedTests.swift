import XCTest
@testable import SwiftUITestbed

final class SwiftUITestbedTests: XCTestCase {
    func testCounterStore() throws {
        let store = CounterStore(initialState: .init(count: 0, favoritesPrimes: []))

        store.assert(store.incr()) {
            $0.count = 1
        }
        store.assert(store.decr()) {
            $0.count = 0
        }
        store.assert(store.presentPrimeModal()) {
            $0.isPrimeModalShown = true
        }
        store.assert(store.incr()) {
            $0.count = 1
        }
        store.assert(store.toggleFavorite()) {
            $0.favoritesPrimes = [1]
        }
    }

    func testCounterViewState() throws {
        let nonFavoritePrime = CounterState(
            count: 1,
            favoritesPrimes: []
        )

        let expected1 = CounterState.ViewState(
            count: 1,
            isPrimeModalShown: false,
            nthPrimeAlert: nil,
            isFavorite: false,
            loading: false
        )
        XCTAssertEqual(nonFavoritePrime.view, expected1)
        XCTAssertEqual(nonFavoritePrime.view.isFavorite, false)
        XCTAssertEqual(nonFavoritePrime.view.isPrime, false)

        let favoritePrime = CounterState(
            count: 2,
            favoritesPrimes: [2]
        )

        let expected2 = CounterState.ViewState(
            count: 2,
            isPrimeModalShown: false,
            nthPrimeAlert: nil,
            isFavorite: true,
            loading: false
        )
        XCTAssertEqual(favoritePrime.view, expected2)
        XCTAssertEqual(favoritePrime.view.isFavorite, true)
        XCTAssertEqual(favoritePrime.view.isPrime, true)

        let nonPrime = CounterState(
            count: 4,
            favoritesPrimes: [2]
        )
        let expected3 = CounterState.ViewState(
            count: 4,
            isPrimeModalShown: false,
            nthPrimeAlert: nil,
            isFavorite: false,
            loading: false
        )
        XCTAssertEqual(nonPrime.view, expected3)
        XCTAssertEqual(nonPrime.view.isFavorite, false)
        XCTAssertEqual(nonPrime.view.isPrime, false)
    }
}


