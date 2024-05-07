//
//  NumberStepperUI.swift
//
//
//  Created by Wonwoo Choi on 5/8/24.
//

import SwiftUI
import SwiftUIExtension

public struct NumberStepperUI: View {
    private let min: Int
    private let max: Int
    @Binding private var number: Int
    private let innerSpacing: CGFloat
    private let font: Font
    
    public init(number: Binding<Int>, min: Int, max: Int, innerSpacing: CGFloat = 40, font: Font = .title3) {
        self._number = number
        self.min = min
        self.max = max
        self.innerSpacing = innerSpacing
        self.font = font
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Button {
                guard number - 1 >= min else { return }
                
                number -= 1
            } label: {
                Image(systemName: "minus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
                .frame(width: innerSpacing)
            
            Text(verbatim: "\(number)")
                .font(font)
            
            Spacer()
                .frame(width: innerSpacing)
            
            Button {
                guard number + 1 <= max else { return }
                
                number += 1
            } label: {
                Image(systemName: "plus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
        .onLoad {
            if number < min {
                number = min
            } else if number > max {
                number = max
            }
        }
    }
}

#Preview {
    @State var number = 10
    return HStack {
        NumberStepperUI(number: $number, min: 1, max: 20, innerSpacing: 20, font: .headline)
            .frame(height: 60)
            .background(Color.red.opacity(0.1))
            .padding(.horizontal, 60)
    }
}
