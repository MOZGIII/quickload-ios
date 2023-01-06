//
//  Layout.swift
//  QuickLoad
//
//  Created by MOZGIII on 06.01.2023.
//

import SwiftUI

struct Layout<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(content: content).scenePadding()
    }
}

struct Layout_Previews: PreviewProvider {
    static var previews: some View {
        Layout {
            Text("Content")
            Text("More content")
        }
    }
}
