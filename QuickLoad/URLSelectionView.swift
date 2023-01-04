//
//  URLSelectionView.swift
//  QuickLoad
//
//  Created by MOZGIII on 04.01.2023.
//

import SwiftUI

struct URLSelectionView: View {
    @Binding var url: String

    var body: some View {
        TextField(
            "Select the URL to download",
            text: $url
        )
    }
}

struct URLSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        URLSelectionView(url: .constant("myurl"))
    }
}
