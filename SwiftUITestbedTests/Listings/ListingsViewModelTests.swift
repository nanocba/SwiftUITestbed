import XCTest
import IdentifiedCollections
@testable import SwiftUITestbed

final class ListingsViewModelTests: XCTestCase {
    func testSetSearchTerm() async throws {
        let allListings = allListings
        let viewModel = ListingsViewModel(allListings: allListings)

        do {
            async let v0: Void = viewModel.performSearch("L")

            let previousSearchTask = viewModel.searchTask

            try await viewModel.assertAsync {
                $0.searchTerm = "L"
            }

            async let v1: Void = viewModel.performSearch("Li")

            print("Awaiting for asserting Li")

            try await viewModel.assertAsync {
                $0.searchTerm = "Li"
            }

            print("Awaiting for asserting Li finished")

            async let v2: Void = viewModel.performSearch("Listing 1")

            try await viewModel.assertAsync(after: 0.5) {
                $0.searchTerm = "Listing 1"
                $0.listings = [allListings[0]]
            }

//            async let v1: Void = viewModel.performSearch("L")
//
//            try await Task.sleep(for: .seconds(0.01))
//
//            print(viewModel.state)
//            let previousTask = viewModel.searchTask
//            print(previousTask)
//            async let v2: Void = viewModel.performSearch("Li")
//
//            let results: [Void] = try await [v1, v2]
//
//            print(viewModel.state)
        } catch {

        }

//        try await viewModel.assert(try await viewModel.performSearch("L")) {
//            $0.searchTerm = "L"
//        }
//
//        try await viewModel.assert(try await viewModel.performSearch("Li")) {
//            $0.searchTerm = "Li"
//        }

//        viewModel.assert(viewModel.setSearchTerm("L")) {
//            $0.searchTerm = "L"
//        }
//
//        viewModel.assert(viewModel.setSearchTerm("Li")) {
//            $0.searchTerm = "Li"
//        }

//        XCTAssertNotNil(viewModel.searchTask)
//        XCTAssertTrue(viewModel.searchTask!.isCancelled)
    }

    var allListings: IdentifiedArrayOf<Listing> {
        .init(uniqueElements: [Listing].all)
    }
}
