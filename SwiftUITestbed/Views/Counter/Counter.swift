import SwiftUI
import SwiftUINavigation

struct Counter: View {
    @Binding var count: Int
    @Binding var favoritesPrimes: [Int]
    @State var store = CounterStore(initialState: .init(count: 0, favoritesPrimes: []))

    var body: some View {
        Observing(store, state: \.view) { state in
            VStack {
                HStack {
                    Button("-", action: { store.decr() })
                    Text("\(state.count)")
                    Button("+", action: { store.incr() })
                }
                Button("Is this prime?", action: { store.presentPrimeModal() } )
                Button("What is the \(ordinal(state.count)) prime?", action: {
                    Task {
                        await store.fetchNthPrime()
                    }
                })
                .disabled(state.loading)

                if state.loading {
                    Text("Fetching the data...")
                        .font(.callout)
                }
            }
            .font(.title)
            .navigationBarTitle("Counter demo")
            .sheet(isPresented: store.binding(\.isPrimeModalShown)) {
                if state.isPrime {
                    Text("\(state.count) is prime 🎉")
                    Button(state.favoriteActionTitle, action: { store.toggleFavorite() })
                } else {
                    Text("\(state.count) is not prime :(")
                }
            }
            .alert(item: store.binding(\.nthPrimeAlert)) { alert in
                Alert(
                    title: Text("The \(ordinal(state.count)) prime is \(alert.prime)"),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .bind($count, to: store.binding(\.count))
            .bind($favoritesPrimes, to: store.binding(\.favoritesPrimes))
        }
    }

    func ordinal(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: n) ?? ""
    }
}

extension CounterState {
    struct ViewState: Equatable {
        let count: Int
        let isPrimeModalShown: Bool
        let nthPrimeAlert: PrimeAlert?
        let isFavorite: Bool
        let loading: Bool

        var favoriteActionTitle: String {
            isFavorite ? "Remove from favorites" : "Add to favorites"
        }

        var isPrime: Bool {
            if count <= 1 { return false }
            if count <= 3 { return true }
            for i in 2...Int(sqrtf(Float(count))) {
              if count % i == 0 { return false }
            }
            return true
        }
    }

    var view: ViewState {
        .init(
            count: count,
            isPrimeModalShown: isPrimeModalShown,
            nthPrimeAlert: nthPrimeAlert,
            isFavorite: isFavorite,
            loading: loading
        )
    }
}

