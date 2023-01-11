import SwiftUI

struct CounterView: View {
    @EnvironmentObject var model: Model

    @ObservedObject var viewModel: CounterViewModel
    @State private var primeModalShown = false

    var body: some View {
        VStack {
            HStack {
                Button("-", action: { model.count -= 1 })
                Text("\(model.count)")
                Button("+", action: { model.count += 1 })
            }
            Button("Is this prime?", action: { primeModalShown = true } )
            Button("What is the \(viewModel.ordinal(model.count)) prime?", action: {
                Task {
                    await viewModel.fetchNthPrime(model.count)
                }
            })
            .disabled(viewModel.loading)

            if viewModel.loading {
                Text("Fetching the data...")
                    .font(.callout)
            }
        }
        .font(.title)
        .navigationBarTitle("Counter demo")
        .sheet(isPresented: $primeModalShown) {
            if viewModel.isPrime(model.count) {
                Text("\(model.count) is prime 🎉")
                Button(viewModel.favoriteActionTitle(isFavorite: model.isCurrentCountFavorite), action: { model.toggleFavorite() })
            } else {
                Text("\(model.count) is not prime :(")
            }
        }
        .alert(item: $viewModel.nthPrimeAlert) { alert in
            Alert(
                title: Text("The \(viewModel.ordinal(model.count)) prime is \(alert.prime)"),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
}
