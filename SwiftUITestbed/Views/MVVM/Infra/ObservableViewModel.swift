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

@dynamicMemberLookup
struct Immutable<Object: AnyObject> {
    private let object: Object
}

extension Immutable {
    init(_ object: Object) {
        self.object = object
    }

    public subscript<ObjectProperty>(dynamicMember keyPath: KeyPath<Object, ObjectProperty>) -> ObjectProperty {
        self.object[keyPath: keyPath]
    }
}
