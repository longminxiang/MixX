//
//  MixO.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

/// MixX Object PropertyWrapper
///
/// Usage
/// ```swift
/// @MixO var name: String = "name"
/// ```
///
@propertyWrapper public struct MixO<Value> {

    private class ValueRef<Value>: ObservableObject {
        let key: MixXCenter.Key

        var value: Value {
            didSet {
                MixXCenter.post(key, userInfo: ["key": key, "oldValue": oldValue])
            }
        }

        @Published var bindingValue: Value {
            didSet {
                if shouldBindingValue?(oldValue, bindingValue) ?? false {
                    value = bindingValue
                }
            }
        }
        var shouldBindingValue: ((Value, Value) -> Bool)?

        init(_ value: Value, key: MixXCenter.Key?) {
            self.value = value
            self.bindingValue = value
            self.key = key ?? .init(String(UUID().uuidString.prefix(8)))
        }
    }

    @ObservedObject private var ref: ValueRef<Value>

    /// Observe Key
    public var key: MixXCenter.Key { ref.key }

    /// A binding to the self, use with (`$`)
    public var projectedValue: Self { self }

    /// Wrapped value
    public var wrappedValue: Value {
        get { ref.value }
        nonmutating set { ref.value = newValue }
    }

    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        ref = ValueRef(wrappedValue, key: key)
    }
}

extension MixO where Value: Equatable {

    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        ref = ValueRef(wrappedValue, key: key)
        ref.shouldBindingValue = { $0 != $1 }
    }

    /// Binding value
    public var binding: Binding<Value> { $ref.bindingValue }
}
