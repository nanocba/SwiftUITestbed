import Combine
import SwiftUI

@dynamicMemberLookup
protocol ObservableViewModel: ObservableObject {
    associatedtype State: Equatable
    var state: State { get set }
}

extension ObservableViewModel {
    public subscript<StateProperty>(dynamicMember keyPath: KeyPath<State, StateProperty>) -> StateProperty {
        self.state[keyPath: keyPath]
    }

    public subscript<StateProperty>(dynamicMember keyPath: WritableKeyPath<State, StateProperty>) -> StateProperty {
        get { self.state[keyPath: keyPath] }
        set { self.state[keyPath: keyPath] = newValue }
    }

    func binding<Value>(get keyPath: KeyPath<State, Value>, set: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: set
        )
    }

    func binding<Value: Identifiable>(get element: Value, set: @escaping (Value.ID, Value) -> Void) -> Binding<Value> {
        Binding(
            get: { element },
            set: { set(element.id, $0) }
        )
    }
}
