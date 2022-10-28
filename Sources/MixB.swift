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
///         } onChange: { name in
///             debugPrint("change \(name)")
///         }
///     }
/// }
/// ```
///
public struct MixB<Content: View, Value: Equatable>: View {
    
    public typealias OnChange<Value: Equatable> = (Value) -> Void

    private class Holder<Value: Equatable>: ObservableObject {
        let binding: MixO<Value>
        let onChange: OnChange<Value>?
        @Published var bindingValue: Value {
            didSet {
                guard binding.wrappedValue != bindingValue else { return }
                binding.wrappedValue = bindingValue
                onChange?(bindingValue)
            }
        }

        init(_ binding: MixO<Value>, onChange: OnChange<Value>?) {
            self.binding = binding
            self.onChange = onChange
            self.bindingValue = binding.wrappedValue

            MixXCenter.add(self, keys: [binding.key]) { [weak self] info in
                guard let s = self else { return }
                guard s.bindingValue != s.binding.wrappedValue else { return }
                s.bindingValue = binding.wrappedValue
                s.onChange?(s.bindingValue)
            }
        }
    }

    @ObservedObject private var holder: Holder<Value>
    private var builder: (Binding<Value>) -> Content

    /// Initor
    public init(_ obj: MixO<Value>, @ViewBuilder builder: @escaping (Binding<Value>) -> Content, onChange: OnChange<Value>? = nil) {
        self.holder = Holder(obj, onChange: onChange)
        self.builder = builder
    }

    /// body
    public var body: some View {
        builder($holder.bindingValue)
    }
}
