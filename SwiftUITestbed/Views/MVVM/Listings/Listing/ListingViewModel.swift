import SwiftUI
import SwiftUINavigation

class EditListingViewModel: ObservableViewModel {
    struct State: Equatable {
        var title: String
        var addressStreet: String
        var addressCity: String
        var addressState: String
        var addressZipCode: String
        var price: String
        var error: String?
        var dismiss: Bool
        var alert: AlertState<AlertAction>?

        var source: Listing

        init(listing: Listing) {
            title = listing.title
            addressStreet = listing.address.streetName
            addressCity = listing.address.city
            addressState = listing.address.state
            addressZipCode = listing.address.zipCode
            price = "\(listing.price)"
            source = listing
            dismiss = false
        }

        enum AlertAction: Equatable {
            case continueEditing
            case dismiss
            case ok
        }
    }

    @Published var state: State

    init(listing: Listing) {
        self.state = .init(listing: listing)
    }

    func updatePrice(_ text: String) {
        guard let value = Double(text) else {
            self.error = "Price should be a valid number."
            return
        }

        guard value > 100 else {
            self.error = "Price should be greater than 100."
            return
        }

        self.price = text
        self.error = nil
    }

    private func inputListing() -> Listing {
        Listing(
            id: self.source.id,
            title: self.title,
            address: .init(
                streetName: self.addressStreet,
                state: self.addressState,
                city: self.addressCity,
                zipCode: self.addressZipCode),
            price: Double(self.price) ?? 0,
            parties: self.source.parties
        )
    }

    func save() {
        guard self.error == nil else {
            self.alert = AlertState(
                title: .init("Unable to save"),
                message: .init("The input provided contains errors."),
                buttons: [.default(.init("OK"))]
            )
            return
        }

        self.source = inputListing()
        self.dismiss = true
    }

    func cancel() {
        guard self.inputListing() == self.source else {
            self.alert = AlertState(
                title: .init("Unsaved changes"),
                message: .init("You have made changes that will be lost if you navigate away."),
                buttons: [
                    .cancel(.init("Continue Editing"), action: .send(.continueEditing)),
                    .default(.init("Navigate Away"), action: .send(.dismiss))
                ]
            )
            return
        }

        self.dismiss = true
    }

    @MainActor func handleAlertAction(_ action: State.AlertAction) {
        switch action {
        case .dismiss:
            self.dismiss = true

        case .continueEditing, .ok:
            break
        }
        self.alert = nil
    }
}

