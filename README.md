# MixX

MixX is a State Manager for SwiftUI.

It can update the part of a view that you only want to update.

## Installation

### Swift Package Manager

Open the following menu item in Xcode:

**File > Add Packages...**

In the **Search or Enter Package URL** search box enter this URL: 

```text
https://github.com/longminxiang/MixX.git
```

Then, select the dependency rule and press **Add Package**.

> 💡 For further reference on SPM, check its [official documentation](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app).


## Usage

1. Replace @State with @MixO

    @MixO var name: String = "aname"


2. Move the View to MixX, Then you can change the name what ever you want

    MixX($name) { name in
        Text(name)
    }


Full example code:

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
                    // Only update this view when the name changed
                    MixX($name) { name in
                        Text(name)
                    }
                }
                HStack {
                    Text("Input: ")
                    MixB($name) { binding in
                        TextField("input name", text: binding)
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
            .padding()
        }
    }
