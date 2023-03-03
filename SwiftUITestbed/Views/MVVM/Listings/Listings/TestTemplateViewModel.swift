//
//  TestTemplateViewModel.swift
//  SwiftUITestbed
//
//  Created by Mariano Donati on 03/03/2023.
//

import Foundation
import SwiftUI

class TestTemplateViewModel: ObservableViewModel {
    struct State: Equatable {

    }

    @Published private(set) var state: State = .init()
}

extension TestTemplateViewModel {
    func binding<Value>(_ keyPath: WritableKeyPath<State, Value>) -> Binding<Value> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
