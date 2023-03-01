import Combine
import SwiftUI

let eventManager = EventManager()

protocol EventlessObservableViewModel: ObservableViewModel where Event == Never {}

extension ObservableViewModel where Event == Never {
    func send(_ event: Event) { }
}

@dynamicMemberLookup
protocol ObservableViewModel: ObservableObject, Observer {
    associatedtype State: Equatable
    associatedtype Event
    var state: State { get }
    func binding<Value: Equatable>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value>
}

extension ObservableViewModel {
    func send(_ event: Event) {
        eventManager.notify(viewModel: self, event: event)
    }

    func observe<ViewModel: ObservableViewModel>(_ viewModelType: ViewModel.Type, closure: @escaping (ViewModel.Event) -> Void) {
        eventManager.add(observer: self, viewModel: viewModelType, closure: closure)
    }

    func unobserve<ViewModel: ObservableViewModel>(_ viewModelType: ViewModel.Type) {
        eventManager.remove(observer: self, viewModel: viewModelType)
    }

    func unobserve() {
        eventManager.remove(observer: self)
    }
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
