//
//  NSError+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import Foundation

public extension NSError {
    convenience init(domain: String = "Error", code: Int = -1, message: String) {
        let userInfo = [NSLocalizedDescriptionKey: message]
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}
