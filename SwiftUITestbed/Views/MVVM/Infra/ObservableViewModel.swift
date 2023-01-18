import Combine
import SwiftUI

protocol ObservableViewModel: ObservableObject {
    associatedtype State: Equatable
    var state: State { get }
}

extension ObservableViewModel {
    func binding<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
