import SwiftUI

extension View {
    func loading(_ value: Bool, alignment: Alignment = .trailing) -> some View {
        modifier(LoadingOverlayViewModifier(loading: value, alignment: alignment))
    }
}

struct LoadingOverlayViewModifier: ViewModifier {
    let loading: Bool
    let alignment: Alignment

    func body(content: LoadingOverlayViewModifier.Content) -> some View {
        content
            .overlay(alignment: alignment) {
                if loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
    }
}
