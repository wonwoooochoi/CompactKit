//
//  View+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import SwiftUI

public extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnLoadModifier(perform: action))
    }
}

fileprivate struct OnLoadModifier: ViewModifier {
    private let action: (() -> Void)?
    @State private var onLoad = false
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            guard onLoad == false else { return }
            onLoad = true
            action?()
        }
    }
}
