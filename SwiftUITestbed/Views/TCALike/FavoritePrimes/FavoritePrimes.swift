import SwiftUI

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
            .bind(store.binding(\.favoritePrimes), to: $favoritePrimes)
        }
    }
}
