//
//  LoadingState.swift
//  QuickLoad
//
//  Created by MOZGIII on 04.01.2023.
//

import Foundation

class LoadingState: ObservableObject {
    @Published var statusMessage: String = "Ready!"
    @Published var error: String? = nil

    func start() {
        statusMessage = "Loading..."
        error = nil
    }

    func stop(error: String?) {
        statusMessage = "Ready!"
        self.error = error
    }
}
