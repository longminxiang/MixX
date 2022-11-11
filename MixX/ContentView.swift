//
//  ContentView.swift
//  MixX
//
//  Created by Eric Long on 2022/9/28.
//

import SwiftUI

struct ContentView: View {
    @MixO var name: String = "aname"
    @MixO var bname: String = "bname"
    @MixO var cname: String = "cname"

    @MixO var show: Bool = false

    init() {
        // It's OK to do this in here
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [self] _ in
            self.bname = "name_\(Int.random(in: 0..<1000))"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            MixX($name).combine($cname).combine($bname) {
                Text("aname: \(name)  bname: \(bname)")
                TextField("input name", text: $name.binding)
                    .padding(8)
                    .background(Color.gray.opacity(0.3))
            }
            .onChange { info in
                debugPrint("on changed \(info)")
            }
            
            MixX($name).build(if: { name != "aname" }) {
                Text("build if aname: \(name)")
            }

            Toggle("show animation text", isOn: $show.binding.animation()).padding(.top, 20)

            MixX($show).build(if: { show }) {
                HStack {
                    Text("animation text")
                    Spacer()
                }
                .transition(.move(edge: .trailing))
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
