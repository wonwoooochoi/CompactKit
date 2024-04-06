//
//  Provider+AsyncAwait.swift
//  
//
//  Created by Wonwoo Choi on 4/7/24.
//

import Foundation
import Provider

public extension Provider {
    func request<M: Decodable>(_ target: T, modelType: M.Type) async throws -> M {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target, modelType: modelType) { result in
                switch result {
                    case let .success(response):
                        continuation.resume(returning: response)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func request(_ target: T) async throws -> (Int, Data) {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                    case let .success(response):
                        continuation.resume(returning: response)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
}
