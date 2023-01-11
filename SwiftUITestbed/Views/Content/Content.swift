import Combine
import SwiftUI

struct Content: View {
    let store: Store<AppState>

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    "Counter Demo",
                    destination: Counter(
                        count: store.binding(\.count),
                        favoritesPrimes: store.binding(\.favoritePrimes)
                    )
                )

                NavigationLink(
                    "Favorites",
                    destination: FavoritePrimes(
                        favoritePrimes: store.binding(\.favoritePrimes)
                    )
                )
            }
            .navigationTitle("State Management")
        }
    }
}
