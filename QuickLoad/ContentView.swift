//
//  ContentView.swift
//  QuickLoad
//
//  Created by MOZGIII on 20.12.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loadingState = LoadingState()
    @SceneStorage("ContentView.url") private var url = "";
    @SceneStorage("ContentView.path") private var path = "";

    var body: some View {
        Layout {
            Text(loadingState.statusMessage).font(.headline)
            Text(loadingState.error ?? "").foregroundColor(Color.red)

            if loadingState.isLoading {
                ProgressView()
            } else {
                InputView(url: $url, path: $path, onLoad: onLoad)
            }
        }
    }

    func onLoad() {
        Task {
            await self.load(url: url, path: path)
        }
    }

    func load(url: String, path: String) async {
        self.loadingState.start()

        let manager = Manager()
        let path = URL.documentsDirectory.appendingPathComponent(path).path(percentEncoded: false)
        let error = await manager.load(url, path)

        self.loadingState.stop(error: error.toString())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
