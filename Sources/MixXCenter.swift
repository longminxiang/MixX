//
//  MixXCenter.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import Foundation

/// MixX Observer Center
///
public struct MixXCenter {

    public typealias Action = (_ info: [AnyHashable: Any]?) -> Void

    /// MixX Observe Key
    ///
    public struct Key {

        /// Raw value
        public let rawValue: String

        /// Initor
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }

    private class WeakRef<Value: AnyObject> {

        weak var value: Value?

        init(_ value: Value) {
            self.value = value
        }
    }

    private static var observers: [(ref: WeakRef<AnyObject>, key: Key, action: Action)] = []

    /// Post Signal to observers
    ///
    /// - Parameter key: The MixXCenter Key.
    /// - Parameter userInfo: Some info.
    public static func post(_ key: Key, userInfo: [AnyHashable: Any]? = nil) {
        observers.removeAll(where: { $0.ref.value == nil })
        for observer in observers {
            if observer.key.rawValue == key.rawValue {
                observer.action(userInfo)
            }
        }
    }

    /// Add an observer with keys and action
    ///
    /// - Parameter observer: The Observer.
    /// - Parameter keys: The MixXCenter Key List.
    /// - Parameter action: Run this action when recive the signal with keys
    public static func add(_ observer: AnyObject, keys: [Key], action: @escaping Action) {
        observers.removeAll(where: { $0.ref.value == nil })
        let obss = keys.map({ (WeakRef(observer), $0, action) })
        observers.append(contentsOf: obss)
    }
}
