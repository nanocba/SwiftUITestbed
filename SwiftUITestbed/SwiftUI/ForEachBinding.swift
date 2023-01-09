import IdentifiedCollections
import SwiftUI

struct ForEachBinding<Data: Identifiable, Content: View>: View {
    @Binding var data: IdentifiedArrayOf<Data>
    let content: (Binding<Data>) -> Content

    init(_ data: Binding<IdentifiedArrayOf<Data>>, @ViewBuilder content: @escaping (Binding<Data>) -> Content) {
        self._data = data
        self.content = content
    }

    var body: some View {
        ForEach(data) { item in
            content(
                Binding(
                    get: { item },
                    set: { data[id: item.id] = $0 }
                )
            )
        }
    }
}

