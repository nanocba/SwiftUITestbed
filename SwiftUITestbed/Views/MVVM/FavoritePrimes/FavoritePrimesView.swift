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

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        //@TODO:
        //Model being too broad is hard to mock it for previews.
        //We need to provide custom initializers to pass different values.
        NavigationStack {
            FavoritePrimesView()
                .environmentObject(Model())
        }
    }
}
