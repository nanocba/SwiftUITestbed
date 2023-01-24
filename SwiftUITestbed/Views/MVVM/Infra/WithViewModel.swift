import SwiftUI

struct WithViewModel<ViewModel: ObservableViewModel, Content: View>: View {
    @StateObject var viewModel: ViewModel
    let state: ViewModel.State
    let content: (ViewModel) -> Content

    private var bindings: (ViewModel) -> AnyView = { _ in EmptyView().eraseToAnyView() }

    init(_ viewModel: @autoclosure @escaping () -> ViewModel, @ViewBuilder content: @escaping (ViewModel) -> Content) {
        let vm = viewModel()
        self._viewModel = StateObject(wrappedValue: vm)
        self.state = vm.state
        self.content = content
    }

    var body: some View {
        EquatableContent(viewModel: viewModel, content: content, state: state)
            .equatable()

        bindings(viewModel)
    }

    func bind<Value: _Bindable>(_ keyPath: ReferenceWritableKeyPath<ViewModel, Value.Value>, to value: Value) -> Self where Value.Value: Equatable {
        var current = self
        current.bindings = { viewModel in
            bindings(viewModel)
                .bind(model: viewModel.binding(keyPath), to: value)
                .eraseToAnyView()
        }
        return current
    }

    func bind<Value: Equatable>(_ keyPath: ReferenceWritableKeyPath<ViewModel, Value>, to value: Value) -> Self {
        var current = self
        current.bindings = { viewModel in
            bindings(viewModel)
                .bind(model: viewModel.binding(keyPath), to: value)
                .eraseToAnyView()
        }
        return current
    }

    private struct EquatableContent: View, Equatable {
        @ObservedObject var viewModel: ViewModel
        let content: (ViewModel) -> Content
        let state: ViewModel.State

        var body: some View {
            content(viewModel)
        }

        static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.state == rhs.state
        }
    }
}

fileprivate extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(erasing: self)
    }
}

fileprivate extension View {
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
    func bind<ModelValue: _Bindable, ViewValue: _Bindable>(
    model modelValue: ModelValue, to viewValue: ViewValue
  ) -> some View
  where ModelValue.Value == ViewValue.Value, ModelValue.Value: Equatable {
    self.modifier(_Bind(modelValue: modelValue, viewValue: viewValue))
  }

    @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
    func bind<ModelValue: _Bindable, ViewValue>(
      model modelValue: ModelValue, to viewValue: ViewValue
    ) -> some View
    where ModelValue.Value == ViewValue, ModelValue.Value: Equatable {
      self.modifier(_BindValue(modelValue: modelValue, viewValue: viewValue))
    }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
private struct _BindValue<ModelValue: _Bindable, ViewValue>: ViewModifier
where ModelValue.Value == ViewValue, ModelValue.Value: Equatable {
  let modelValue: ModelValue
  let viewValue: ViewValue

  @State var hasAppeared = false

    func body(content: _BindValue.Content) -> some View {
    content
      .onAppear {
        guard !self.hasAppeared else { return }
        self.hasAppeared = true
        guard self.viewValue != self.modelValue.wrappedValue else { return }
          self.modelValue.wrappedValue = self.viewValue
      }
      .onChange(of: self.viewValue) {
        guard self.modelValue.wrappedValue != $0
        else { return }
        self.modelValue.wrappedValue = $0
      }
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
        guard self.viewValue.wrappedValue != $0
        else { return }
        self.viewValue.wrappedValue = $0
      }
      .onChange(of: self.viewValue.wrappedValue) {
        guard self.modelValue.wrappedValue != $0
        else { return }
        self.modelValue.wrappedValue = $0
      }
  }
}

protocol _Bindable {
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
