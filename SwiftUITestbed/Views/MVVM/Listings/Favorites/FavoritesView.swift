import IdentifiedCollections
import SwiftUI

struct WithViewModel<ViewModel: ObservableViewModel, Content: View>: View {
    @StateObject var viewModel: ViewModel
    let content: (ViewModel) -> Content

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

struct FavoritesView: View {
    @EnvironmentObject var favoritesModel: FavoritesModel
    @Binding var allListings: IdentifiedArrayOf<Listing>

    var body: some View {
        WithViewModel(FavoritesViewModel.init, favoritesModel, allListings) { viewModel in
            NavigationStack {
                List {
                    ForEach(viewModel.favorites) { favoriteListing in
                        ListingNavigationLink(
                            listing: viewModel.binding(
                                get: favoriteListing,
                                set: viewModel.setListing)
                        )
                    }
                }
                .navigationTitle("Favorites")
                .bind(model: viewModel.binding(\.allListings), to: $allListings)
                .bind(model: viewModel.binding(\.favoritesIds), to: favoritesModel.favorites)
            }
        }
    }
}
