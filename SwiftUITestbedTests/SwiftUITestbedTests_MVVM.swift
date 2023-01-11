import XCTest
@testable import SwiftUITestbed

final class SwiftUITestbedTests_MVVM: XCTestCase {
    func testCounterViewModel() throws {
        let viewModel = CounterViewModel()

        viewModel.incr()
        XCTAssertEqual(viewModel.count, 1)

        viewModel.decr()
        XCTAssertEqual(viewModel.count, 0)

        viewModel.presentPrimeModal()
        XCTAssertEqual(viewModel.primeModalShown, true)

        viewModel.incr()
        XCTAssertEqual(viewModel.count, 1)
    }
}



