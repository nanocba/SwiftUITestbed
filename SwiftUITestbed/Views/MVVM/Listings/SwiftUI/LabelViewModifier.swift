import SwiftUI

struct LabelViewModifier: ViewModifier {
    let label: String

    func body(content: LabelViewModifier.Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.callout)
                .foregroundColor(.gray)

            content
                .font(.body)
        }
    }
}

extension View {
    func label(_ label: String) -> some View {
        modifier(LabelViewModifier(label: label))
    }
}
