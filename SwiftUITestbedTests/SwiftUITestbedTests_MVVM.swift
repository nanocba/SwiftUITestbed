import XCTest
@testable import SwiftUITestbed

final class SwiftUITestbedTests_MVVM: XCTestCase {
    func testCounterViewModel() throws {
        let viewModel = CounterViewModel()

        viewModel.assert(viewModel.incr()) {
            $0.count = 0
        }
        viewModel.assert(viewModel.decr()) {
            $0.count = 0
        }
        viewModel.assert(viewModel.presentPrimeModal()) {
            $0.primeModalShown = true
        }
        viewModel.assert(viewModel.incr()) {
            $0.count = 1
        }
        viewModel.assert(viewModel.toggleFavorite()) {
            $0.favoritePrimes = [1]
        }
    }
}



