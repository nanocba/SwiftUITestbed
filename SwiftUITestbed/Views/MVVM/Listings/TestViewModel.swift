//
//  TestViewModel.swift
//  SwiftUITestbed
//
//  Created by Mariano Donati on 18/01/2023.
//

import Foundation
import SwiftUI

class TestViewModel: ObservableViewModel {
    struct State: Equatable {

    }

    @Published private(set) var state: State = .init()
}

extension TestViewModel {
    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
