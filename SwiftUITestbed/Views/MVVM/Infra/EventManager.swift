import Foundation

class EventManager {
    private var registrations = [any RegistrationProtocol]()

    func add<T: Observer, Event>(observer: T, closure: @escaping (Event) -> Void) {
        guard !exists(observer: observer, eventType: Event.self) else { return }
        registrations.append(Registration(parent: observer, closure: closure))
    }

    func remove<T: Observer, Event>(observer: T, eventType: Event.Type) {
        registrations.removeAll(where: matching(observer: observer, eventType: eventType))
    }

    func remove<T: Observer>(observer: T) {
        registrations.removeAll(where: matching(observer: observer))
    }

    func notify<Event>(_ event: Event) {
        for registration in registrations.filter(matching(eventType: type(of: event))) {
            registration.notify(event: event)
        }
    }

    private func exists<T: Observer, Event>(observer: T, eventType: Event.Type) -> Bool {
        registrations.contains(where: matching(observer: observer, eventType: eventType))
    }

    private func matching<T: Observer, Event>(observer: T, eventType: Event.Type) -> (any RegistrationProtocol) -> Bool {
        { self.matching(observer: observer)($0) && self.matching(eventType: eventType)($0) }
    }

    private func matching<T: Observer>(observer: T) -> (any RegistrationProtocol) -> Bool {
        { $0.parent.objectIdentifier == observer.objectIdentifier }
    }

    private func matching<Event>(eventType: Event.Type) -> (any RegistrationProtocol) -> Bool {
        { $0.canHandle(eventType) }
    }
}

protocol Observer: AnyObject {}

extension Observer {
    var objectIdentifier: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}

fileprivate protocol RegistrationProtocol {
    associatedtype Event
    associatedtype Parent: Observer
    var parent: Parent { get }
    var closure: (Event) -> Void { get }
}

extension RegistrationProtocol {
    func canHandle<E>(_ eventType: E.Type) -> Bool {
        eventType == Event.self
    }

    func notify<E>(event e: E) {
        guard let event = event(e) else { return }
        closure(event)
    }

    private func event<E>(_ e: E) -> Event? {
        e as? Event
    }
}

fileprivate struct Registration<Parent: Observer, Event>: RegistrationProtocol {
    let parent: Parent
    let closure: (Event) -> Void
}
