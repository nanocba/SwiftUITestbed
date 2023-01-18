import SwiftUI
import SwiftUINavigation

class EditListingViewModel: ObservableViewModel {
    struct State: Equatable {
        var title: String
        var addressStreet: String
        var addressCity: String
        var addressState: String
        var addressZipCode: String
        fileprivate var price: String
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

    @Published private(set) var state: State

    init(listing: Listing) {
        self.state = .init(listing: listing)
    }

    var price: String {
        get { state.price }
        set {
            guard let value = Double(newValue) else {
                state.error = "Price should be a valid number."
                return
            }

            guard value > 100 else {
                state.error = "Price should be greater than 100."
                return
            }

            state.price = newValue
            state.error = nil
        }
    }

    private func inputListing() -> Listing {
        Listing(
            id: state.source.id,
            title: state.title,
            address: .init(
                streetName: state.addressStreet,
                state: state.addressState,
                city: state.addressCity,
                zipCode: state.addressZipCode),
            price: Double(state.price) ?? 0,
            parties: state.source.parties
        )
    }

    func save() {
        guard state.error == nil else {
            state.alert = AlertState(
                title: .init("Unable to save"),
                message: .init("The input provided contains errors."),
                buttons: [.default(.init("OK"))]
            )
            return
        }

        state.source = inputListing()
        state.dismiss = true
    }

    func cancel() {
        guard self.inputListing() == state.source else {
            state.alert = AlertState(
                title: .init("Unsaved changes"),
                message: .init("You have made changes that will be lost if you navigate away."),
                buttons: [
                    .cancel(.init("Continue Editing"), action: .send(.continueEditing)),
                    .default(.init("Navigate Away"), action: .send(.dismiss))
                ]
            )
            return
        }

        state.dismiss = true
    }

    @MainActor func handleAlertAction(_ action: State.AlertAction) {
        switch action {
        case .dismiss:
            state.dismiss = true

        case .continueEditing, .ok:
            break
        }
        state.alert = nil
    }

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}

