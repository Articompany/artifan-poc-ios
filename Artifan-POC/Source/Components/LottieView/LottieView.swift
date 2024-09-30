//
//  LottieView.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI
import Lottie

struct LottieComponent: UIViewRepresentable {
    let name: AnimationsAvailables
    let loopMode: LottieLoopMode
    let animationEnd: () -> Void
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: name.rawValue)
        animationView.play { _ in
            animationEnd()
        }
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}

enum AnimationsAvailables: String {
    case confetti
}
