import SwiftUI
import SwiftUINavigation

struct Counter: View {
    @Binding var count: Int
    @Binding var favoritesPrimes: [Int]
    @State var store = CounterStore(initialState: .init(count: 0, favoritesPrimes: []))

//    init(count: Binding<Int>, favoritesPrimes: Binding<[Int]>) {
//        self._count = count
//        self._favoritesPrimes = favoritesPrimes
//        store.state.count = count.wrappedValue
//        store.state.favoritesPrimes = favoritesPrimes.wrappedValue
//    }

    var body: some View {
        Observing(store, state: \.view) { state in
            VStack {
                HStack {
                    Button("-", action: store.decr)
                    Text("\(state.count)")
                    Button("+", action: store.incr)
                }
                Button("Is this prime?", action: store.presentPrimeModal)
                Button(
                    "What is the \(ordinal(state.count)) prime?",
                    action: {}
                )
            }
            .font(.title)
            .navigationBarTitle("Counter demo")
            .sheet(isPresented: store.binding(\.isPrimeModalShown)) {
                Button("Save to favorites", action: store.saveToFavorites)
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
    }

    var view: ViewState {
        .init(
            count: count,
            isPrimeModalShown: isPrimeModalShown,
            nthPrimeAlert: nthPrimeAlert
        )
    }
}

