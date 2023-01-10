import Combine
import SwiftUI

@dynamicMemberLookup
public class Store<State: Equatable> {
    public typealias Action = (inout State) -> Void

    fileprivate var _state: CurrentValueSubject<State, Never>

    private var parentCancellable: AnyCancellable?
    private var childrenCancellables = Set<AnyCancellable>()

    required init(initialState: State) {
        self._state = .init(initialState)
    }

    func scope<LocalState, LocalStore: Store<LocalState>>(
        state child: WritableKeyPath<State, LocalState>
    ) -> LocalStore {
        scope(initialState: { $0[keyPath: child] }, state: child, parent: \.self)
    }

    func scope<ParentState, LocalState, LocalStore: Store<LocalState>>(
        initialState: (State) -> LocalState,
        state child: WritableKeyPath<State, ParentState>,
        parent localToParent: KeyPath<LocalState, ParentState>
    ) -> LocalStore {
        let childStore = LocalStore(initialState: initialState(state))
        childStore._state
            .dropFirst()
            .sink { [weak self] newValue in
                self?.state[keyPath: child] = newValue[keyPath: localToParent]
            }
            .store(in: &childrenCancellables)
        return childStore
    }

    func rescoped<LocalStore: Store<State>>() -> LocalStore {
        scope(state: \.self)
    }

    var state: State {
        get { _state.value }
        set { _state.value = newValue }
    }

    public func binding<Value>(
        _ keyPath: WritableKeyPath<State, Value>
    ) -> Binding<Value> {
        self._state.binding(keyPath)
    }

    public func binding<Value>(
        get: @escaping (State) -> Value,
        set: @escaping (Value) -> Void
    ) -> Binding<Value> {
        Binding(
            get: { get(self.state) },
            set: { set($0) }
        )
    }

    public subscript<StateProperty>(dynamicMember keyPath: KeyPath<State, StateProperty>) -> StateProperty {
        self.state[keyPath: keyPath]
    }

    public subscript<StateProperty>(dynamicMember keyPath: WritableKeyPath<State, StateProperty>) -> StateProperty {
        get { self.state[keyPath: keyPath] }
        set { self.state[keyPath: keyPath] = newValue }
    }

    public func send(_ action: Action) {
        var state = self.state
        action(&state)
        self.state = state
    }
}

class ViewStore<ViewState: Equatable>: ObservableObject {
    @Published var state: ViewState
    private var cancellable: AnyCancellable?

    required init<State: Equatable, StoreType: Store<State>>(_ store: StoreType, observe: @escaping (State) -> ViewState) {
        self.state = observe(store._state.value)
        cancellable = store._state.sink { [weak self] newValue in
            let newValue = observe(newValue)
            if newValue != self?.state {
                self?.state = newValue
            }
        }
    }

    deinit {
        print("Deinit view store")
    }
}

extension CurrentValueSubject {
//  var binding: Binding<Output> {
//    Binding(get: {
//      self.value
//    }, set: {
//      self.send($0)
//    })
//  }

    func binding<Value>(_ keyPath: WritableKeyPath<Output, Value>) -> Binding<Value> {
        Binding(
            get: {
                self.value[keyPath: keyPath]
            },
            set: {
                var value = self.value
                value[keyPath: keyPath] = $0
                self.send(value)
            }
        )
    }
}

