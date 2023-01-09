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
    @State private var manager: Manager?;

    var body: some View {
        Layout {
            Text(loadingState.isLoading ? "Loading..." : "Ready!").font(.headline)
            Text(loadingState.error ?? "").foregroundColor(Color.red)

            if loadingState.isLoading {
                ProgressView(
                    cancellationState: loadingState.cancellationState,
                    onCancel: cancel
                )
            } else {
                InputView(url: $url, path: $path, onLoad: load)
            }
        }
    }

    func load() {
        Task {
            await self.loadingState.load(url: url, path: path)
        }
    }

    func cancel() {
        self.loadingState.cancel()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
