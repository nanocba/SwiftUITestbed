import Foundation
import IdentifiedCollections
import SwiftUI

class ListingsContentViewModel: EventlessObservableViewModel {
    struct State: Equatable {
        var tab: Tab
        var allListings: IdentifiedArrayOf<Listing>

        enum Tab: Equatable {
            case listings
            case favorites
        }
    }

    @Published private(set) var state: State = .init(tab: .listings, allListings: [])

    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
