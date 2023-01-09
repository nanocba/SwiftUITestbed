import SwiftUI

struct Counter: View {
    let store: CounterStore

    var body: some View {
        Observing(store, state: \.count) { count in
            VStack {
                HStack {
                    Button("-", action: store.decr)
                    Text("\(count)")
                    Button("+", action: store.incr)
                }
                Button("Is this prime?", action: store.presentPrimeModal)
                Button(
                    "What is the \(ordinal(count)) prime?",
                    action: {}
                )
            }
            .font(.title)
            .navigationBarTitle("Counter demo")
            .sheet(isPresented: store.binding(\.isPrimeModalShown)) {
                EmptyView()
            }
            .alert(item: store.binding(\.nthPrimeAlert)) { alert in
                Alert(
                    title: Text("The \(ordinal(count)) prime is \(alert.prime)"),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }

    func ordinal(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: n) ?? ""
    }
}

