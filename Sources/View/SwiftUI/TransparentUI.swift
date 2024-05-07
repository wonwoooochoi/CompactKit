//
//  TransparentUI.swift
//  
//
//  Created by Wonwoo Choi on 5/7/24.
//

import SwiftUI

public struct TransparentUI: UIViewRepresentable {
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}
