import SwiftUI

struct IfLet<Item, Content: View>: View {
    @Binding var item: Item?
    let then: (Binding<Item>) -> Content

    init(_ item: Binding<Item?>, @ViewBuilder then: @escaping (Binding<Item>) -> Content) {
        self._item = item
        self.then = then
    }

    var body: some View {
        if let value = item {
            then(
                Binding(
                    get: { value },
                    set: { item = $0 }
                )
            )
        }
    }
}
