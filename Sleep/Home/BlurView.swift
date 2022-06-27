//
//  BlurView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 24/06/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    typealias UIViewType = UIVisualEffectView
    
    func makeUIView(context: Context) -> UIViewType {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

