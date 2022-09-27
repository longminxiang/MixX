//
//  MixO.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import Foundation

/// MixX Object PropertyWrapper
///
/// Usage
/// ```swift
/// @MixO var name: String = "eric"
/// ```
///
@propertyWrapper public struct MixO<Value> {

    private class ValueRef<Value> {
        var value: Value

        init(_ value: Value) {
            self.value = value
        }
    }

    private var ref: ValueRef<Value>
    /// Observe Key
    public let key: MixXCenter.Key = .init(String(UUID().uuidString.prefix(8)))

    /// A binding to the self, use with (`$`)
    public var projectedValue: Self { self }

    /// Wrapped value
    public var wrappedValue: Value {
        get { ref.value }
        nonmutating set {
            let oldValue = ref.value
            ref.value = newValue
            MixXCenter.post(key, userInfo: ["oldValue": oldValue])
        }
    }

    /// Initor
    public init(wrappedValue: Value) {
        self.ref = ValueRef(wrappedValue)
    }
}
