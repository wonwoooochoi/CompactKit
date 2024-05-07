//
//  LoadingUI.swift
//  
//
//  Created by Wonwoo Choi on 5/7/24.
//

import SwiftUI

public struct LoadingUI: View {
    private let tint: Color
    private let scale: CGSize
    
    public init(tint: Color = .white, scale: CGSize = CGSize(width: 2, height: 2)) {
        self.tint = tint
        self.scale = scale
    }
    
    public var body: some View {
        ZStack {
            Color.black
                .opacity(0.2)
            
            ProgressView()
                .scaleEffect(scale, anchor: .center)
                .progressViewStyle(.circular)
                .tint(tint)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TransparentUI())
    }
}

#Preview {
    LoadingUI()
}
