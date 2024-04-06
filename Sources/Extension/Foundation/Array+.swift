//
//  Array+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
