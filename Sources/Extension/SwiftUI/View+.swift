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
    
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}
