import Combine
import SwiftUI

let eventManager = EventManager()

@dynamicMemberLookup
protocol ObservableViewModel: ObservableObject, Observer {
    associatedtype State: Equatable
    var state: State { get }
    func binding<Value: Equatable>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value>
}

extension ObservableViewModel {
    func send<Event>(_ event: Event) {
        eventManager.notify(event)
    }

    func observe<Event>(_ closure: @escaping (Event) -> Void) {
        eventManager.add(observer: self, closure: closure)
    }

    func unobserve<Event>(_ eventType: Event.Type) {
        eventManager.remove(observer: self, eventType: eventType)
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
