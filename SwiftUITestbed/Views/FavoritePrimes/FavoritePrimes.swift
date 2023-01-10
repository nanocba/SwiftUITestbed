import SwiftUI
import SwiftUINavigation

struct FavoritePrimes: View {
    @Binding var favoritePrimes: [Int]
    @State private var store = FavoritePrimesStore(initialState: .init(favoritePrimes: []))

    var body: some View {
        Observing(store, state: \.favoritePrimes) { favoritePrimes in
            List {
                ForEach(favoritePrimes, id: \.self) { favoritePrime in
                    Text("\(favoritePrime)")
                }
                .onDelete(perform: store.deleteFavoritePrime)
            }
            .navigationBarTitle("Favorites Primes")
            .bind($favoritePrimes, to: store.binding(\.favoritePrimes))
        }
    }
}
