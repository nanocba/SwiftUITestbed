import XCTest
import SwiftUINavigation
@testable import SwiftUITestbed

final class EditListingViewModelTests: XCTestCase {
    func testSave() {
        let listing = subjectListing
        let viewModel = EditListingViewModel(listing: listing)

        viewModel.assert(viewModel.save()) {
            $0.source = listing
            $0.dismiss = true
        }
    }

    func testShouldNotSaveIfInputContainsErrors() {
        let listing = subjectListing
        let viewModel = EditListingViewModel(listing: listing)

        viewModel.assert(viewModel.updatePrice("90")) {
            $0.error = "Price should be greater than 100."
        }

        viewModel.assert(viewModel.save()) {
            $0.alert = AlertState(
                title: .init("Unable to save"),
                message: .init("The input provided contains errors."),
                buttons: [.default(.init("OK"))]
            )
        }
    }

    func testCancellingWithoutChangesNavigatesAway() {
        let listing = subjectListing
        let viewModel = EditListingViewModel(listing: listing)

        viewModel.assert(viewModel.cancel()) {
            $0.dismiss = true
        }
    }

    func testCancellingWithUnsavedChangesAlert() {
        let listing = subjectListing
        let viewModel = EditListingViewModel(listing: listing)

        viewModel.assert(viewModel.title = "New Listing name") {
            $0.title = "New Listing name"
        }

        viewModel.assert(viewModel.cancel()) {
            $0.alert = AlertState(
                title: .init("Unsaved changes"),
                message: .init("You have made changes that will be lost if you navigate away."),
                buttons: [
                    .cancel(.init("Continue Editing"), action: .send(.continueEditing)),
                    .default(.init("Navigate Away"), action: .send(.dismiss))
                ]
            )
        }
    }

    var subjectListing: Listing {
        Listing(
            id: UUID(),
            title: "Listing 1",
            address: .init(
                streetName: "Infinite Loop 345",
                state: "California",
                city: "San Francisco",
                zipCode: "90210"
            ),
            price: 110000,
            parties: []
        )
    }
}
