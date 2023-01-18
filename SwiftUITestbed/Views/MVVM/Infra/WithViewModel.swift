import SwiftUI

struct WithTestViewModel<ViewModel: ObservableViewModel, Content: View>: View {
    @ObservedObject var viewModel: ViewModel
    let content: (ViewModel) -> Content

    var body: some View {
        self.content(viewModel)
    }
}

struct WithViewModel<ViewModel: ObservableViewModel, Content: View>: View {
    @StateObject var viewModel: ViewModel
    let state: ViewModel.State
    let content: (ViewModel) -> Content

    init(_ viewModel: @escaping () -> ViewModel, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        let vm = viewModel()
        self._viewModel = StateObject(wrappedValue: vm)
        self.state = vm.state
        self.content = content
    }

    init<Dependency>(_ viewModel: @escaping (Dependency) -> ViewModel, _ dependency: Dependency, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        let vm = viewModel(dependency)
        self._viewModel = StateObject(wrappedValue: vm)
        self.state = vm.state
        self.content = content
    }

    init<D1, D2>(_ viewModel: @escaping (D1, D2) -> ViewModel, _ dependency1: D1, _ dependency2: D2, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        let vm = viewModel(dependency1, dependency2)
        self._viewModel = StateObject(wrappedValue: vm)
        self.state = vm.state
        self.content = content
    }

    init<D1, D2, D3>(_ viewModel: @escaping (D1, D2, D3) -> ViewModel, _ dependency1: D1, _ dependency2: D2, _ dependency3: D3, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        let vm = viewModel(dependency1, dependency2, dependency3)
        self._viewModel = StateObject(wrappedValue: vm)
        self.state = vm.state
        self.content = content
    }

    var body: some View {
        EquatableContent(viewModel: viewModel, content: content, state: state)
            .equatable()
    }

    private struct EquatableContent: View, Equatable {
        @ObservedObject var viewModel: ViewModel
        let content: (ViewModel) -> Content
        let state: ViewModel.State

        var body: some View {
            content(viewModel)
        }

        static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.state == rhs.state
        }
    }

}
