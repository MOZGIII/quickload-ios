//
//  Styles.swift
//  QuickLoad
//
//  Created by MOZGIII on 06.01.2023.
//

import SwiftUI

extension View {
    public func styledButton() -> some View {
        self.buttonStyle(.borderedProminent)
    }
}

extension View {
    public func styledTextField() -> some View {
        self
            .padding()
            .background(Color(.tertiarySystemFill))
            .containerShape(RoundedRectangle(cornerRadius: 16))

    }
}
