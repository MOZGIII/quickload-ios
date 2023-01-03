//
//  ContentView.swift
//  QuickLoad
//
//  Created by MOZGIII on 20.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State var statusMessage = "Ready!"
    @State var content = ""
    @State var error = ""

    var body: some View {
        VStack {
            Text(self.statusMessage)
            Text(self.error)
            Button(action: {
                Task {
                    await self.load()
                }
            }) {
                Text("Load")
            }
            Text(self.content)
        }
        .padding()
    }

    func load() async {
        self.statusMessage = "Loading..."
        self.error = ""

        let manager = Manager()
        let url = "https://raw.githubusercontent.com/chinedufn/swift-bridge/master/examples/async-functions/src/lib.rs"
        let path = URL.documentsDirectory.appendingPathComponent("myio.txt").path(percentEncoded: false)
        let error = await manager.load(url, path)

        self.statusMessage = "Ready!"
        self.error = error.toString()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
