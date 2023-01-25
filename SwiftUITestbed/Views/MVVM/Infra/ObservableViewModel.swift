import Combine
import SwiftUI

@dynamicMemberLookup
protocol ObservableViewModel: ObservableObject {
    associatedtype State: Equatable
    var state: State { get }
    func binding<Value: Equatable>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value>
}

extension ObservableViewModel {
    public subscript<StateProperty>(dynamicMember keyPath: KeyPath<State, StateProperty>) -> StateProperty {
        self.state[keyPath: keyPath]
    }

    func binding<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
