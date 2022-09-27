//
//  ContentView.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    @MixO var name: String = "aname"

    init() {
        // It's OK to do this in init function
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [self] _ in
            self.name = "name_\(Int.random(in: 0..<1000))"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Name: ")
                // Only update this view when name changed
                MixX($name) { name in
                    Text(name)
                }
            }
            HStack {
                Text("Input: ")
                MixB($name) { binding in
                    TextField("input name", text: binding)
                        .padding(8)
                        .background(Color.gray.opacity(0.3))
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
