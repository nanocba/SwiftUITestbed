import Combine
import SwiftUI

struct Observing<ViewState: Equatable, Content: View>: View {
    @ObservedObject var viewStore: ViewStore<ViewState>
    let content: (ViewState) -> Content

    init(_ store: Store<ViewState>, @ViewBuilder content: @escaping (ViewState) -> Content) {
        self.init(store, state: { $0 }, content: content)
    }

    init<State: Equatable>(_ store: Store<State>, state observe: @escaping (State) -> ViewState, @ViewBuilder content: @escaping (ViewState) -> Content) {
        self.viewStore = ViewStore(store, observe: observe)
        self.content = content
    }

    var body: some View {
        self.content(viewStore.state)
    }
}

