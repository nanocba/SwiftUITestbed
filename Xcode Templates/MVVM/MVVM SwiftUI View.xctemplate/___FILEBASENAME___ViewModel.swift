//___FILEHEADER___

import Foundation
import SwiftUI

class ___FILEBASENAMEASIDENTIFIER___: ObservableViewModel {
    struct State: Equatable {

    }

    @Published private(set) var state: State = .init()
}

extension ___FILEBASENAMEASIDENTIFIER___ {
    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
