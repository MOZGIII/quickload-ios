//
//  LoadingState.swift
//  QuickLoad
//
//  Created by MOZGIII on 04.01.2023.
//

import Foundation

@MainActor
class LoadingState: ObservableObject {
    @Published var manager: Manager?
    @Published var error: String?
    @Published var cancellationState: CancellationEffect?

    var isLoading: Bool { manager != nil }

    func load(url: String, path: String) async {
        guard !isLoading else { return }

        let path = URL.documentsDirectory
            .appendingPathComponent(path)
            .path(percentEncoded: false)

        let manager = Manager()

        self.manager = manager
        self.cancellationState = nil

        self.error = nil
        let error = await manager.load(url, path)
        self.error = error.toString()

        self.manager = nil
    }

    func cancel() {
        cancellationState = manager?.cancel()
    }
}
