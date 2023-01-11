import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Counter Demo",
                    destination: CounterView(
                        viewModel: CounterViewModel()
                    )
                )

                NavigationLink(
                    "Favorites",
                    destination: FavoritePrimesView(
                        viewModel: FavoritePrimesViewModel()
                    )
                )
            }
            .navigationTitle("State Management")
        }
    }
}
