import Combine
import SwiftUI

struct Content: View {
    let store: Store<AppState>

    var body: some View {
        Observing(store, state: \.count) { count in
            NavigationView {
                List {
                    NavigationLink(
                        "Counter Demo",
                        destination: Counter(count: store.binding(\.count))
                    )

                    NavigationLink(
                        "Favorites",
                        destination: FavoritePrimes(store: store.favoritePrimes)
                    )

                    Text("\(count)")
                }
                .navigationTitle("State Management")
            }
        }
    }
}

extension Store where State == AppState {
    var counter: CounterStore {
        scope(
            initialState: { .init(count: $0.count) },
            state: \.count,
            parent: \.count
        )
    }

    var favoritePrimes: FavoritePrimesStore {
        scope(
            state: \.favoritePrimesState
        )
    }
}
