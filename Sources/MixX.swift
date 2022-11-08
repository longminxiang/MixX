//
//  MixX.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

/// MixXKey for MixX initialize
///
public protocol MixXKey {
    var mixXKey: MixXCenter.Key { get }
}

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
///                 MixX($name) {
///                     Text(name)
///                 }
///                 .onChange { _ in
///                     debugPrint("name changed")
///                 }
///             }
///             HStack {
///                 Text("Input: ")
///                 MixX($name) {
///                     TextField("input name", text: $name.binding)
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

    private class Holder: ObservableObject {
        @Published private var i: Bool = false

        var onChange: ((_ info: [AnyHashable: Any]) -> Void)?

        var keys: [MixXCenter.Key] = [] {
            didSet {
                MixXCenter.remove(self)
                MixXCenter.add(self, keys: keys) { [weak self] info in
                    self?.i.toggle()
                    self?.onChange?(info ?? [:])
                }
            }
        }
    }

    @ObservedObject private var holder = Holder()
    private var builder: (() -> Content?)?
    
    public init(_ key: MixXKey) {
        holder.keys.append(key.mixXKey)
    }
    
    public init(_ key: MixXKey, @ViewBuilder builder: @escaping () -> Content) {
        self.init(key)
        self.builder = builder
    }

    public var body: some View {
        builder?()
    }
}

extension MixX {
    
    public func combine(_ key: MixXKey) -> MixX {
        holder.keys.append(key.mixXKey)
        return self
    }

    public func combine(_ key: MixXKey, @ViewBuilder builder: @escaping () -> Content) -> MixX {
        var s = combine(key)
        s.builder = builder
        return s
    }
    
    public func onChange(_ action: @escaping (_ info: [AnyHashable: Any]) -> Void) -> MixX {
        holder.onChange = action
        return self
    }
    
    public func build(if condition: @escaping () -> Bool, @ViewBuilder builder: @escaping () -> Content) -> MixX {
        var s = self
        s.builder = { condition() ? builder() : nil }
        return s
    }
}

extension MixXCenter.Key: MixXKey {
    public var mixXKey: MixXCenter.Key { self }
}

extension MixO: MixXKey {
    public var mixXKey: MixXCenter.Key { key }
}
