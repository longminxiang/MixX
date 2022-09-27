//
//  MixB.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

/// Use with input binding
///
/// Usage
/// ```swift
/// struct TestView: View {
///     @MixO var name: String = "aname"
///
///     var body: some View {
///         MixB($name) { binding in
///             TextField("input name", text: binding)
///         }
///     }
/// }
/// ```
///
public struct MixB<Content: View, Value: Equatable>: View {

    private class Holder<Value: Equatable>: ObservableObject {
        let binding: MixO<Value>
        @Published var bindingValue: Value {
            didSet {
                guard binding.wrappedValue != bindingValue else { return }
                binding.wrappedValue = bindingValue
            }
        }

        init(_ binding: MixO<Value>) {
            self.binding = binding
            self.bindingValue = binding.wrappedValue

            MixXCenter.add(self, keys: [binding.key]) { [weak self] info in
                guard let s = self else { return }
                guard s.bindingValue != s.binding.wrappedValue else { return }
                s.bindingValue = binding.wrappedValue
            }
        }
    }

    @ObservedObject private var holder: Holder<Value>
    private var builder: (Binding<Value>) -> Content

    /// Initor
    public init(_ obj: MixO<Value>, @ViewBuilder builder: @escaping (Binding<Value>) -> Content) {
        self.holder = Holder(obj)
        self.builder = builder
    }

    /// body
    public var body: some View {
        builder($holder.bindingValue)
    }
}
