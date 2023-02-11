//
//  MixO.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

open class MixOValueRef<Value> {

    let key: MixXCenter.Key

    public var value: Value

    public init(_ value: Value, key: MixXCenter.Key?) {
        self.value = value
        self.key = key ?? .init(String(UUID().uuidString.prefix(8)))
    }

    open func resetWrappedValue(_ newValue: Value) {
        let oldValue = value
        value = newValue
        MixXCenter.post(key, userInfo: ["key": key, "oldValue": oldValue])
    }
}

/// MixX Object PropertyWrapper
///
/// Usage
/// ```swift
/// @MixO var name: String = "name"
/// ```
///
@propertyWrapper public struct MixO<Value> {

    public var ref: MixOValueRef<Value>

    /// Observe Key
    public var key: MixXCenter.Key { ref.key }

    /// A binding to the self, use with (`$`)
    public var projectedValue: Self { self }

    /// Wrapped value
    public var wrappedValue: Value {
        get { ref.value }
        nonmutating set { ref.resetWrappedValue(newValue) }
    }

    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        ref = .init(wrappedValue, key: key)
    }
}

open class MixOEquatableValueRef<Value: Equatable>: MixOValueRef<Value> {

    public var lockBinding: Bool = false

    public var _binding: Binding<Value>?

    public var binding: Binding<Value> {
        if let b = _binding { return b }
        _binding = Binding<Value>(
            get: { [self] in value },
            set: { [self] in
                guard value != $0 else { return }
                lockBinding = true
                resetWrappedValue($0)
                lockBinding = false
            }
        )
        return _binding!
    }

    override open func resetWrappedValue(_ newValue: Value) {
        guard value != newValue else { return }
        super.resetWrappedValue(newValue)
        if !lockBinding { _binding = nil }
    }
}

extension MixO where Value: Equatable {

    public var equatableRef: MixOEquatableValueRef<Value> { ref as! MixOEquatableValueRef<Value> }

    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        ref = MixOEquatableValueRef(wrappedValue, key: key)
    }

    public var binding: Binding<Value> { equatableRef.binding }
}
