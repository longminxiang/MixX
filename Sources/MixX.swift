//
//  MixX.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

/// MixX use in body for SwiftUI, It can update a part of the view witch you only want to.
///
/// Usage
/// ```swift
/// struct ContentView: View {
///     @MixO var name: String = "aname"
///
///     init() {
///         Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self] _ in
///             self.name = "name_\(Int.random(in: 0..<1000))"
///         }
///     }
///
///     var body: some View {
///         VStack(alignment: .leading) {
///             HStack {
///                 Text("Name: ")
///                 // Only update this view when name changed
///                 MixX($name) { name in
///                     Text(name)
///                 }
///             }
///             HStack {
///                 Text("Input: ")
///                 MixB($name) { binding in
///                     TextField("input name", text: binding)
///                         .background(Color.gray.opacity(0.3))
///                 }
///             }
///         }
///         .padding()
///     }
/// }
/// ```
///
public struct MixX<Content: View>: View {
    
    public typealias OnChange = () -> Void

    private class Trigger: ObservableObject {
        @Published private(set) var i: Bool = false
        private let onChange: OnChange?
        
        init(_ keys: [MixXCenter.Key], onChange: OnChange?) {
            self.onChange = onChange
            MixXCenter.add(self, keys: keys) { [weak self] info in
                self?.i.toggle()
                self?.onChange?()
            }
        }
    }

    public typealias Builder = () -> Content

    @ObservedObject private var trigger: Trigger
    private var builder: Builder

    /// Initor
    public init(_ keys: [MixXCenter.Key], @ViewBuilder builder: @escaping Builder, onChange: OnChange? = nil) {
        self.builder = builder
        self.trigger = Trigger(keys, onChange: onChange)
    }

    /// body
    public var body: some View {
        builder()
    }
}

extension MixX {

    public typealias Builder1<T1> = (T1) -> Content
    public typealias Builder2<T1, T2> = (_ vals: (T1, T2)) -> Content
    public typealias Builder3<T1, T2, T3> = (_ vals: (T1, T2, T3)) -> Content
    public typealias Builder4<T1, T2, T3, T4> = (_ vals: (T1, T2, T3, T4)) -> Content
    public typealias Builder5<T1, T2, T3, T4, T5> = (_ vals: (T1, T2, T3, T4, T5)) -> Content
    public typealias Builder6<T1, T2, T3, T4, T5, T6> = (_ vals: (T1, T2, T3, T4, T5, T6)) -> Content

    public typealias OnChange1<T1> = (T1) -> Void
    public typealias OnChange2<T1, T2> = (_ vals: (T1, T2)) -> Void
    public typealias OnChange3<T1, T2, T3> = (_ vals: (T1, T2, T3)) -> Void
    public typealias OnChange4<T1, T2, T3, T4> = (_ vals: (T1, T2, T3, T4)) -> Void
    public typealias OnChange5<T1, T2, T3, T4, T5> = (_ vals: (T1, T2, T3, T4, T5)) -> Void
    public typealias OnChange6<T1, T2, T3, T4, T5, T6> = (_ vals: (T1, T2, T3, T4, T5, T6)) -> Void

    /// Initor
    public init<T1>(
        _ obj: MixO<T1>,
        @ViewBuilder builder: @escaping Builder1<T1>,
        onChange: OnChange1<T1>? = nil)
    {
        self.init([obj.key]) {
            builder(obj.wrappedValue)
        } onChange: {
            onChange?(obj.wrappedValue)
        }
    }

    /// Initor
    public init<T1, T2>(
        _ o1: MixO<T1>, _ o2: MixO<T2>,
        @ViewBuilder builder: @escaping Builder2<T1, T2>,
        onChange: OnChange2<T1, T2>? = nil)
    {
        self.init([o1.key, o2.key]) {
            builder((o1.wrappedValue, o2.wrappedValue))
        } onChange: {
            onChange?((o1.wrappedValue, o2.wrappedValue))
        }
    }

    /// Initor
    public init<T1, T2, T3>(
        _ o1: MixO<T1>, _ o2: MixO<T2>, _ o3: MixO<T3>,
        @ViewBuilder builder: @escaping Builder3<T1, T2, T3>,
        onChange: OnChange3<T1, T2, T3>? = nil)
    {
        self.init([o1.key, o2.key, o3.key]) {
            builder((o1.wrappedValue, o2.wrappedValue, o3.wrappedValue))
        } onChange: {
            onChange?((o1.wrappedValue, o2.wrappedValue, o3.wrappedValue))
        }
    }

    /// Initor
    public init<T1, T2, T3, T4>(
        _ o1: MixO<T1>, _ o2: MixO<T2>, _ o3: MixO<T3>, _ o4: MixO<T4>,
        @ViewBuilder builder: @escaping Builder4<T1, T2, T3, T4>,
        onChange: OnChange4<T1, T2, T3, T4>? = nil)
    {
        self.init([o1.key, o2.key, o3.key, o4.key]) {
            builder((o1.wrappedValue, o2.wrappedValue, o3.wrappedValue, o4.wrappedValue))
        } onChange: {
            onChange?((o1.wrappedValue, o2.wrappedValue, o3.wrappedValue, o4.wrappedValue))
        }
    }

    /// Initor
    public init<T1, T2, T3, T4, T5>(
        _ o1: MixO<T1>, _ o2: MixO<T2>, _ o3: MixO<T3>, _ o4: MixO<T4>, _ o5: MixO<T5>,
        @ViewBuilder builder: @escaping Builder5<T1, T2, T3, T4, T5>,
        onChange: OnChange5<T1, T2, T3, T4, T5>? = nil)
    {
        self.init([o1.key, o2.key, o3.key, o4.key, o5.key]) {
            builder((
                o1.wrappedValue, o2.wrappedValue, o3.wrappedValue,
                o4.wrappedValue, o5.wrappedValue
            ))
        } onChange: {
            onChange?((
                o1.wrappedValue, o2.wrappedValue, o3.wrappedValue,
                o4.wrappedValue, o5.wrappedValue
            ))
        }
    }

    /// Initor
    public init<T1, T2, T3, T4, T5, T6>(
        _ o1: MixO<T1>, _ o2: MixO<T2>, _ o3: MixO<T3>,
        _ o4: MixO<T4>, _ o5: MixO<T5>, _ o6: MixO<T6>,
        @ViewBuilder builder: @escaping Builder6<T1, T2, T3, T4, T5, T6>,
        onChange: OnChange6<T1, T2, T3, T4, T5, T6>? = nil)
    {
        self.init([o1.key, o2.key, o3.key, o4.key, o5.key, o6.key]) {
            builder((
                o1.wrappedValue, o2.wrappedValue, o3.wrappedValue,
                o4.wrappedValue, o5.wrappedValue, o6.wrappedValue
            ))
        } onChange: {
            onChange?((
                o1.wrappedValue, o2.wrappedValue, o3.wrappedValue,
                o4.wrappedValue, o5.wrappedValue, o6.wrappedValue
            ))
        }
    }
}
