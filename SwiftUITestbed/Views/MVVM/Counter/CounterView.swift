import SwiftUI

struct CounterView: View {
    @EnvironmentObject var model: Model
    @ObservedObject var viewModel: CounterViewModel

    var body: some View {
        VStack {
            HStack {
                Button("-", action: { viewModel.decr() })
                Text("\(viewModel.count)")
                Button("+", action: { viewModel.incr() })
            }
            Button("Is this prime?", action: { viewModel.presentPrimeModal() } )
            Button("What is the \(viewModel.ordinal) prime?", action: {
                Task {
                    await viewModel.fetchNthPrime()
                }
            })
            .disabled(viewModel.loading)

            if viewModel.loading {
                Text("Fetching the data...")
                    .font(.callout)
            }

            NavigationLink(
                "Favorites",
                destination: FavoritePrimesView(viewModel: FavoritePrimesViewModel())
            )
        }
        .font(.title)
        .navigationBarTitle("Counter demo")
        .sheet(isPresented: $viewModel.primeModalShown) {
            if viewModel.isPrime {
                Text("\(viewModel.count) is prime 🎉")
                Button(viewModel.favoriteActionTitle, action: { viewModel.toggleFavorite() })
            } else {
                Text("\(viewModel.count) is not prime :(")
            }
        }
        .alert(item: $viewModel.nthPrimeAlert) { alert in
            Alert(
                title: Text("The \(viewModel.ordinal) prime is \(alert.prime)"),
                dismissButton: .default(Text("Ok"))
            )
        }
        .bind(model: $viewModel.count, to: $model.count)
        .bind(model: $viewModel.favoritePrimes, to: $model.favoritePrimes)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(viewModel: CounterViewModel())
            .environmentObject(Model())
    }
}
