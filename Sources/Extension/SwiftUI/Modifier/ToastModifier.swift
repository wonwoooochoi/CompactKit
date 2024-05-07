//
//  ToastModifier.swift
//  
//
//  Created by Wonwoo Choi on 5/7/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let message: String
    private let disppearDelay: Double
    private let rounding: CGFloat
    private let opacity: Double
    
    init(isPresented: Binding<Bool>, message: String, disppearDelay: Double = 2, rounding: CGFloat = 5, opacity: Double = 0.8) {
        self._isPresented = isPresented
        self.message = message
        self.disppearDelay = disppearDelay
        self.rounding = rounding
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        HStack(alignment: .center, spacing: 0) {
                            Spacer(minLength: 10)
                            
                            Text(message)
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.all, 10)
                                .background (
                                    Color.black
                                        .opacity(opacity)
                                        .clipShape(RoundedRectangle(cornerRadius: rounding))
                                )
                            
                            Spacer(minLength: 10)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: 0.5)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + disppearDelay) {
                                withAnimation {
                                    self.isPresented = false
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 10)
                    }
                    .padding(.horizontal, 10)
                    .allowsHitTesting(false)
                }
            }
    }
}
