import Foundation

class EventManager {
    private var registrations = [any RegistrationProtocol]()

    func add<T: Observer, ViewModel: ObservableViewModel>(observer: T, viewModel viewModelType: ViewModel.Type, closure: @escaping (ViewModel.Event) -> Void) {
        guard !exists(observer: observer, viewModelType: viewModelType) else { return }
        registrations.append(Registration<T, ViewModel>(parent: observer, closure: closure))
    }

    func remove<T: Observer, ViewModel: ObservableViewModel>(observer: T, viewModel viewModelType: ViewModel.Type) {
        registrations.removeAll(where: matching(observer: observer, viewModelType: viewModelType))
    }

    func remove<T: Observer>(observer: T) {
        registrations.removeAll(where: matching(observer: observer))
    }

    func notify<ViewModel: ObservableViewModel>(viewModel: ViewModel, event: ViewModel.Event) {
        for registration in registrations.filter(matching(viewModelType: type(of: viewModel))) {
            registration.notify(viewModel, event: event)
        }
    }

    private func exists<T: Observer, ViewModel: ObservableViewModel>(observer: T, viewModelType: ViewModel.Type) -> Bool {
        registrations.contains(where: matching(observer: observer, viewModelType: viewModelType))
    }

    private func matching<T: Observer, ViewModel: ObservableViewModel>(observer: T, viewModelType: ViewModel.Type) -> (any RegistrationProtocol) -> Bool {
        { self.matching(observer: observer)($0) && self.matching(viewModelType: viewModelType)($0) }
    }

    private func matching<T: Observer>(observer: T) -> (any RegistrationProtocol) -> Bool {
        { $0.parent.objectIdentifier == observer.objectIdentifier }
    }

    private func matching<ViewModel: ObservableViewModel>(viewModelType: ViewModel.Type) -> (any RegistrationProtocol) -> Bool {
        { $0.canHandle(viewModelType) }
    }
}

protocol Observer: AnyObject {}

extension Observer {
    var objectIdentifier: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}

fileprivate protocol RegistrationProtocol {
    associatedtype ViewModel: ObservableViewModel
    associatedtype Parent: Observer
    var parent: Parent { get }
    var closure: (ViewModel.Event) -> Void { get }
}

extension RegistrationProtocol {
    func canHandle<ViewModel: ObservableViewModel>(_ viewModelType: ViewModel.Type) -> Bool {
        viewModelType == ViewModel.self
    }

    func notify<ViewModel: ObservableViewModel>(_ viewModel: ViewModel, event e: ViewModel.Event) {
        guard let event = event(e) else { return }
        closure(event)
    }

    private func event<E>(_ e: E) -> ViewModel.Event? {
        e as? ViewModel.Event
    }
}

fileprivate struct Registration<Parent: Observer, ViewModel: ObservableViewModel>: RegistrationProtocol {
    let parent: Parent
    let closure: (ViewModel.Event) -> Void
}
