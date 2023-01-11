import SwiftUI

struct FavoritePrimesView: View {
    @EnvironmentObject var model: Model

    var body: some View {
        List {
            ForEach(model.favoritePrimes, id: \.self) { favoritePrime in
                Text("\(favoritePrime)")
            }
            .onDelete(perform: model.deleteFavoritePrime)
        }
        .navigationBarTitle("Favorites Primes")
    }
}
