import SwiftUI
import Combine

@main
struct SwiftUITestbedApp: App {
    let store = Store(initialState: AppState())
    var body: some Scene {
        WindowGroup {
            Content(store: store)
            //GranularStateObjectTest.MainViewWithObservedObjectView()
            //StateObjectTest.MainView()
        }
    }
}

struct GranularStateObjectTest {
    class S: ObservableObject {
        @Published var count1: Int = 0
        @Published var count2: Int = 0
    }

    struct MainView: View {
        @StateObject var state = S()

        var body: some View {
            NavigationStack {
                List {
                    NavigationLink(
                        "Counter 1",
                        destination: Counter(count: $state.count1)
                    )

                    NavigationLink(
                        "Counter 2",
                        destination: Counter(count: $state.count2)
                    )
                }
            }
        }
    }

    struct MainViewWithObservedObjectView: View {
        @StateObject var state = S()

        var body: some View {
            ObservedObjectView(state: state)
        }
    }

    struct ObservedObjectView: View {
        @ObservedObject var state: S

        var body: some View {
            NavigationStack {
                List {
                    NavigationLink(
                        "Counter 1",
                        destination: Counter(count: $state.count1)
                    )

                    NavigationLink(
                        "Counter 2",
                        destination: Counter(count: $state.count2)
                    )
                }
            }
        }
    }

    struct Counter: View {
        @Binding var count: Int

        var body: some View {
            VStack {
                Text("\(count)")
                Button("Increment", action: { count += 1 })
            }
        }
    }
}

struct StateObjectTest {
    class S: ObservableObject {
        @Published var state: State

        init(state: State) {
            self.state = state
        }
    }

    struct State: Equatable {
        var count1: Int = 0
        var count2: Int = 0

        var counter1State: Int {
            get { count1 }
            set { count1 = newValue }
        }

        var counter2State: Int {
            get { count2 }
            set { count2 = newValue }
        }
    }

    struct MainView: View {
        @StateObject var state = S(state: .init())

        var body: some View {
            NavigationStack {
                List {
                    NavigationLink(
                        "Counter 1",
                        destination: Counter(count: $state.state.count1)
                    )

                    NavigationLink(
                        "Counter 2",
                        destination: Counter(count: $state.state.count2)
                    )
                }
            }
        }
    }

    struct ObservedView: View {
        @StateObject var state = S(state: .init())

        var body: some View {
            ObservingState(initialState: state.state, publisher: state.$state.eraseToAnyPublisher(), observe: \.count2) { _ in
                NavigationStack {
                    List {
                        NavigationLink(
                            "Counter 1",
                            destination: Counter(count: $state.state.count1)
                        )

                        NavigationLink(
                            "Counter 2",
                            destination: Counter(count: $state.state.count2)
                        )
                    }
                }
            }
        }
    }

    struct StoreView: View {
        let store: Store<State> = .init(initialState: .init())

        var body: some View {
            NavigationStack {
                List {
                    NavigationLink(
                        "Counter 1",
                        destination: StoreCounter(store: store.scope(state: \.counter1State))
                    )

                    NavigationLink(
                        "Counter 2",
                        destination: StoreCounter(store: store.scope(state: \.counter2State))
                    )
                }
            }
        }
    }

    struct Counter: View {
        @Binding var count: Int

        var body: some View {
            VStack {
                Text("\(count)")
                Button("Increment", action: { count += 1 })
            }
        }
    }

    struct StoreCounter: View {
        let store: Store<Int>

        var body: some View {
            Observing(store) { count in
                VStack {
                    Text("\(count)")
                    Button("Increment", action: { store.state += 1 })
                }
            }
        }
    }

    class ViewStore<ViewState: Equatable>: ObservableObject {
        @Published var state: ViewState
        private var cancellable: AnyCancellable?

        required init<State: Equatable>(initialState: State, publisher: AnyPublisher<State, Never>, observe: @escaping (State) -> ViewState) {
            self.state = observe(initialState)
            cancellable = publisher.sink { [weak self] newValue in
                let newValue = observe(newValue)
                if newValue != self?.state {
                    self?.state = newValue
                }
            }
        }

        deinit {
            print("Deinit view store")
        }
    }

    struct ObservingState<ViewState: Equatable, Content: View>: View {
        @ObservedObject var viewStore: ViewStore<ViewState>
        let content: (ViewState) -> Content

        init<State: Equatable>(initialState: State, publisher: AnyPublisher<State, Never>, observe: @escaping (State) -> ViewState, @ViewBuilder content: @escaping (ViewState) -> Content) {
            self.viewStore = ViewStore(initialState: initialState, publisher: publisher, observe: observe)
            self.content = content
        }

        var body: some View {
            self.content(viewStore.state)
        }
    }
}
