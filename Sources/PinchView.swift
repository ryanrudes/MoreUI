//
//  PinchView.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/18/21.
//

import SwiftUI

struct PinchView<Content>: View where Content: View {
    var content: () -> Content
    
    @State var lastScale: CGFloat = 1
    @State var scale: CGFloat = 1
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        let gesture = MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value
                scale *= delta
            }
            .onEnded { value in
                lastScale = 1
            }
        
        content()
            .scaleEffect(scale)
            .gesture(gesture)
    }
}

extension View {
    func pinchToZoom() -> some View {
        PinchView {
            self
        }
    }
}
