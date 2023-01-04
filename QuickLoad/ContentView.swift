//
//  ContentView.swift
//  QuickLoad
//
//  Created by MOZGIII on 20.12.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loadingState = LoadingState()

    var body: some View {
        VStack {
            Text(loadingState.statusMessage)
            Text(loadingState.error ?? "").foregroundColor(Color.red)
            Button(action: {
                Task {
                    await self.load()
                }
            }) {
                Text("Load")
            }
        }
        .padding()
    }

    func load() async {
        self.loadingState.start()

        let manager = Manager()
        let url = "https://raw.githubusercontent.com/chinedufn/swift-bridge/master/examples/async-functions/src/lib.rs"
        let path = URL.documentsDirectory.appendingPathComponent("myio.txt").path(percentEncoded: false)
        let error = await manager.load(url, path)

        self.loadingState.stop(error: error.toString())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
