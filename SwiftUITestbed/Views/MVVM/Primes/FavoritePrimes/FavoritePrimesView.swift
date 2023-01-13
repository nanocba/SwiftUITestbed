import SwiftUI

struct FavoritePrimesView: View {
    @EnvironmentObject var model: Model
    @ObservedObject var viewModel: FavoritePrimesViewModel

    var body: some View {
        List {
            ForEach(viewModel.favoritePrimes, id: \.self) { favoritePrime in
                Text("\(favoritePrime)")
            }
            .onDelete(perform: viewModel.deleteFavoritePrime)
        }
        .navigationBarTitle("Favorites Primes")
        .bind(model: $viewModel.favoritePrimes, to: $model.favoritePrimes)
    }
}

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        //@TODO:
        //Model being too broad is hard to mock it for previews.
        //We need to provide custom initializers to pass different values.
        NavigationStack {
            FavoritePrimesView(viewModel: FavoritePrimesViewModel())
                .environmentObject(Model())
        }
    }
}
