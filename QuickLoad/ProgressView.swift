//
//  ProgressView.swift
//  QuickLoad
//
//  Created by MOZGIII on 06.01.2023.
//

import SwiftUI

struct ProgressView: View {
    var cancellationState: CancellationEffect?
    var onCancel: () -> Void

    var body: some View {
        Text("Loading...")
        Button("Cancel", action: onCancel)
            .styledButton()

        if let effect = cancellationState {
            Text(cancellationEffectText(effect: effect))
        }
    }

    func cancellationEffectText(effect: CancellationEffect) -> String {
        switch effect {
        case .IssuedWithWriteQueue: return "cancelling"
        case .IssuedWithDropQueue: return "cancelling (not waiting for writes)"
        case .NoEffect: return "cancelling (you can stop pressing already)"
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Layout {
            ProgressView(
                cancellationState: nil,
                onCancel: {
                    print("cancel")
                }
            )
        }
        Layout {
            ProgressView(
                cancellationState: .IssuedWithWriteQueue,
                onCancel: {
                    print("cancel")
                }
            )
        }
        Layout {
            ProgressView(
                cancellationState: .IssuedWithDropQueue,
                onCancel: {
                    print("cancel")
                }
            )
        }
        Layout {
            ProgressView(
                cancellationState: .NoEffect,
                onCancel: {
                    print("cancel")
                }
            )
        }
    }
}
