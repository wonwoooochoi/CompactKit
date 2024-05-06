//
//  DateFormatter+.swift
//
//
//  Created by Wonwoo Choi on 5/7/24.
//

import Foundation

public extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
