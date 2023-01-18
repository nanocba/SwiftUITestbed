import SwiftUI

struct WithViewModel<ViewModel: ObservableViewModel, Content: View>: View {
    @StateObject var viewModel: ViewModel
    let content: (ViewModel) -> Content

    init(_ viewModel: @escaping () -> ViewModel, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        self._viewModel = StateObject(wrappedValue: viewModel())
        self.content = content
    }

    init<Dependency>(_ viewModel: @escaping (Dependency) -> ViewModel, _ dependency: Dependency, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        self._viewModel = StateObject(wrappedValue: viewModel(dependency))
        self.content = content
    }

    init<D1, D2>(_ viewModel: @escaping (D1, D2) -> ViewModel, _ dependency1: D1, _ dependency2: D2, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        self._viewModel = StateObject(wrappedValue: viewModel(dependency1, dependency2))
        self.content = content
    }

    init<D1, D2, D3>(_ viewModel: @escaping (D1, D2, D3) -> ViewModel, _ dependency1: D1, _ dependency2: D2, _ dependency3: D3, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        self._viewModel = StateObject(wrappedValue: viewModel(dependency1, dependency2, dependency3))
        self.content = content
    }

    var body: some View {
        self.content(self.viewModel)
    }
}
