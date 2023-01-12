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
            .toolbar {
                // 2
                EditButton()
            }
            .bind(model: store.binding(\.favoritePrimes), to: $favoritePrimes)
        }
    }
}

struct FavoritePrimes_Previews: PreviewProvider {
    static var previews: some View {
        WithState(initialValue: [2, 5]) { favoritePrimes in
            NavigationStack {
                FavoritePrimes(favoritePrimes: favoritePrimes)
            }
        }
    }
}
