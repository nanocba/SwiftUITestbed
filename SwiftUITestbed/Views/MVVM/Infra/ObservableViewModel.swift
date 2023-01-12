import Combine

@dynamicMemberLookup
protocol ObservableViewModel: ObservableObject {
    associatedtype State: Equatable
    var state: State { get set }
}

extension ObservableViewModel {
    func update(_ closure: (inout State) -> Void) {
        var current = state
        closure(&current)
        state = current
    }
}

extension ObservableViewModel {
    public subscript<StateProperty>(dynamicMember keyPath: KeyPath<State, StateProperty>) -> StateProperty {
        self.state[keyPath: keyPath]
    }

    public subscript<StateProperty>(dynamicMember keyPath: WritableKeyPath<State, StateProperty>) -> StateProperty {
        get { self.state[keyPath: keyPath] }
        set { self.state[keyPath: keyPath] = newValue }
    }
}
