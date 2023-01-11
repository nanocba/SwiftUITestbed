import Combine
import SwiftUI

struct Observing<ViewState: Equatable, Content: View>: View {
    @ObservedObject var viewStore: ViewStore<ViewState>
    let content: (ViewState) -> Content

    init(_ store: Store<ViewState>, @ViewBuilder content: @escaping (ViewState) -> Content) {
        self.init(store, state: { $0 }, content: content)
    }

    init<State: Equatable>(_ store: Store<State>, state observe: @escaping (State) -> ViewState, @ViewBuilder content: @escaping (ViewState) -> Content) {
        self.viewStore = ViewStore(store, observe: observe)
        self.content = content
    }

    var body: some View {
        self.content(viewStore.state)
    }
}

extension View {
  /// Synchronizes model state to view state via two-way bindings.
  ///
  /// SwiftUI comes with many property wrappers that can be used in views to drive view state, like
  /// field focus. Unfortunately, these property wrappers _must_ be used in views. It's not possible
  /// to extract this logic to an observable object and integrate it with the rest of the model's
  /// business logic, and be in a better position to test this state.
  ///
  /// We can work around these limitations by introducing a published field to your observable
  /// object and synchronizing it to view state with this view modifier.
  ///
  /// - Parameters:
  ///   - modelValue: A binding from model state. _E.g._, a binding derived from a published field
  ///     on an observable object.
  ///   - viewValue: A binding from view state. _E.g._, a focus binding.
  @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
  public func bind<ModelValue: _Bindable, ViewValue: _Bindable>(
    _ modelValue: ModelValue, to viewValue: ViewValue
  ) -> some View
  where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    self.modifier(_Bind(modelValue: modelValue, viewValue: viewValue))
  }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
private struct _Bind<ModelValue: _Bindable, ViewValue: _Bindable>: ViewModifier
where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
  let modelValue: ModelValue
  let viewValue: ViewValue

  @State var hasAppeared = false

    func body(content: _Bind.Content) -> some View {
    content
      .onAppear {
        guard !self.hasAppeared else { return }
        self.hasAppeared = true
        guard self.viewValue.wrappedValue != self.modelValue.wrappedValue else { return }
          self.modelValue.wrappedValue = self.viewValue.wrappedValue
      }
      .onChange(of: self.modelValue.wrappedValue) {
          print("on change of model value \($0) view value \(self.viewValue.wrappedValue)")
        guard self.viewValue.wrappedValue != $0
        else { return }
        self.viewValue.wrappedValue = $0
          print("view value changed")
          print("----")
      }
      .onChange(of: self.viewValue.wrappedValue) {
          print("on change of view value \($0) model value \(self.modelValue.wrappedValue)")
        guard self.modelValue.wrappedValue != $0
        else { return }
        self.modelValue.wrappedValue = $0
          print("model value changed")
          print("----")
      }
  }
}

public protocol _Bindable {
  associatedtype Value
  var wrappedValue: Value { get nonmutating set }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension AccessibilityFocusState: _Bindable {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension AccessibilityFocusState.Binding: _Bindable {}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
extension AppStorage: _Bindable {}

extension Binding: _Bindable {}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
extension FocusedBinding: _Bindable {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension FocusState: _Bindable {}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension FocusState.Binding: _Bindable {}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
extension SceneStorage: _Bindable {}

extension State: _Bindable {}

