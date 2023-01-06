//
//  InputView.swift
//  QuickLoad
//
//  Created by MOZGIII on 06.01.2023.
//

import SwiftUI

struct InputView: View {
    @Binding var url: String
    @Binding var path: String
    var onLoad: () -> Void

    var body: some View {
        TextField("URL", text: $url)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .styledTextField()
        TextField("File path", text: $path)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .styledTextField()
        Button("Load", action: onLoad)
            .styledButton()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        Layout {
            InputView(
                url: .constant("http://example.org/myfile.bin"),
                path: .constant("myfile.bin"),
                onLoad: {
                    print("loading")
                }
            )
        }
        Layout {
            InputView(
                url: .constant(""),
                path: .constant(""),
                onLoad: {
                    print("loading")
                }
            )
        }
    }
}
