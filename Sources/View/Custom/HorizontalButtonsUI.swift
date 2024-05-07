//
//  HorizontalButtonsUI.swift
//
//
//  Created by Wonwoo Choi on 5/8/24.
//

import SwiftUI

public struct HorizontalButtonsUI: View {
    private let titles: [String]
    private let innerSpacing: CGFloat
    private let font: Font
    private let textColor: Color
    private let action: (Int) -> Void
    
    public init(titles: [String], innerSpacing: CGFloat = 20, font: Font = .title3, textColor: Color = .black, action: @escaping (Int) -> Void) {
        self.titles = titles
        self.innerSpacing = innerSpacing
        self.font = font
        self.textColor = textColor
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: innerSpacing) {
            ForEach(titles.indices, id: \.self) { index in
                let title = titles[index]
                
                Button {
                    action(index)
                } label: {
                    HStack(spacing: 0) {
                        Text(title)
                            .font(font)
                            .foregroundStyle(textColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 0.5)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    return HStack {
        HorizontalButtonsUI(titles: ["짬뽕", "짜장면"]) { index in
            print(index)
        }
        .frame(height: 60)
        .background(Color.red.opacity(0.1))
        .padding(.horizontal, 60)
    }
}
