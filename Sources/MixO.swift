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
        @Published var value: Value {
            didSet { didSetObj?(value) }
        }

        var didSetObj: ((Value) -> Void)?

        init(_ value: Value, didset: ((Value) -> Void)? = nil) {
            self.value = value
            self.didSetObj = didset
        }
    }

    @ObservedObject private var ref: ValueRef<Value>

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

    private init(_ wrappedValue: Value, key: MixXCenter.Key? = nil) {
        self.key = key ?? .init(String(UUID().uuidString.prefix(8)))
        self.ref = ValueRef(wrappedValue)
    }
}

extension MixO {
    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        self.init(wrappedValue, key: key)
    }
}

extension MixO where Value: Equatable {

    public init(wrappedValue: Value, key: MixXCenter.Key? = nil) {
        self.init(wrappedValue, key: key)
        self.ref = ValueRef(wrappedValue) { [self] in
            guard self.wrappedValue != $0 else { return }
            self.wrappedValue = $0
        }
    }

    /// Binding value
    public var binding: Binding<Value> { $ref.value }
}
