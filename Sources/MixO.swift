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

    private class ValueRef<Value> {
        var value: Value

        init(_ value: Value) {
            self.value = value
        }
    }

    private var ref: ValueRef<Value>
    /// Observe Key
    public let key: MixXCenter.Key

    /// A binding to the self, use with (`$`)
    public var projectedValue: Self { self }

    /// Wrapped value
    public var wrappedValue: Value {
        get { ref.value }
        nonmutating set {
            let oldValue = ref.value
            ref.value = newValue
            MixXCenter.post(key, userInfo: ["key": key, "oldValue": oldValue])
        }
    }

    /// Initor
    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        self.key = key ?? .init(String(UUID().uuidString.prefix(8)))
        self.ref = ValueRef(wrappedValue)
    }
}

extension MixO where Value: Equatable {

    /// Binding value
    public var binding: Binding<Value> {
        .init(
            get: { wrappedValue },
            set: { if wrappedValue != $0 { wrappedValue = $0 } }
        )
    }
}
