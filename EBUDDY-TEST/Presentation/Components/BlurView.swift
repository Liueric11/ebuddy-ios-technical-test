//
//  BlurView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 22/12/24.
//

import Foundation
import SwiftUI
import UIKit


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    init(style: UIBlurEffect.Style = .systemUltraThinMaterial) {
        self.style = style
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
