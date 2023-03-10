import XCTest
import IdentifiedCollections
@testable import SwiftUITestbed
import Combine

class TestViewModel: ObservableViewModel {
    struct State: Equatable {
        var count: Int = 0
        var loading: Bool = false
    }

    @Published private(set) var state: State

    init() {
        self.state = .init()
    }

    func incr() async throws {
        try await Task.sleep(for: .seconds(0.5))
        state.count += 1
    }

    func incrWithLoading() async throws {
        state.loading = true
        try await Task.sleep(for: .seconds(0.5))
        state.count += 1
        state.loading = false
    }

    func fakeIncr() async throws {
        state.loading = true
        try await Task.sleep(for: .seconds(0.5))
    }
}

final class TestViewModelTests: XCTestCase {
    func testIncr() async throws {
        let viewModel = TestViewModel()

        try await viewModel.assertThrowing(
            try await viewModel.incr(),
            .afterSuspension {
                $0.count = 1
            }
        )
    }

    func testIncrWithLoading() async throws {
        let viewModel = TestViewModel()

        try await viewModel.assertThrowing(
            try await viewModel.incrWithLoading(),
            .before({
                $0.loading = true
            }, after: {
                $0.count = 1
                $0.loading = false
            })
        )
    }

    func testFakeIncr() async throws {
        let viewModel = TestViewModel()

        try await viewModel.assertThrowing(
            try await viewModel.fakeIncr(),
            .beforeSuspension({
                $0.loading = true
            })
        )
    }
}

//final class ListingsViewModelTests: XCTestCase {
//    func testSearch() async throws {
//        let allListings = allListings
//        let viewModel = ListingsViewModel(allListings: allListings)
//        viewModel.searchTerm = "Listing 1"
//
//        let value = try await viewModel.assertThrowing(
//            try await viewModel.search(),
//            beforeSuspension: {
//                $0.searching = true
//            },
//            afterSuspension: {
//                $0.searching = false
//            }
//        )
//        XCTAssertEqual(value, [allListings[0]])
//    }
//
//    func testFetchAllListings() async {
//        let allListings = allListings
//        let viewModel = ListingsViewModel(allListings: [])
//
//        await viewModel.assert(
//            await viewModel.fetchAllListings(),
//            beforeSuspension: {
//                $0.loading = true
//            },
//            afterSuspension: {
//                $0.loading = false
//                $0.allListings = allListings
//                $0.listings = allListings
//            }
//        )
//    }
//
//    func testPerformSearch() async throws {
//        let allListings = allListings
//        let viewModel = ListingsViewModel(allListings: allListings)
//
//        try await viewModel.assertThrowing(
//            try await viewModel.performSearch("L"),
//            beforeSuspension: {
//                $0.searchTerm = "L"
//            },
//            afterSuspension: {
//                $0.listings = allListings
//            }
//        )
//
//        try await viewModel.assertThrowing(
//            try await viewModel.performSearch("Li"),
//            beforeSuspension: {
//                $0.searchTerm = "Li"
//            },
//            afterSuspension: {
//                $0.listings = allListings
//            }
//        )
//
//        try await viewModel.assertThrowing(
//            try await viewModel.performSearch("Listing 1"),
//            beforeSuspension: {
//                $0.searchTerm = "Listing 1"
//            },
//            afterSuspension: {
//                $0.listings = [allListings[0]]
//            }
//        )
//    }
//
//    var allListings: IdentifiedArrayOf<Listing> {
//        .init(uniqueElements: [Listing].all)
//    }
//}
