//
//  Provider.swift
//
//
//  Created by Wonwoo Choi on 4/6/24.
//

import Foundation
import Moya

final public class Provider<T: TargetType> {
    public let moyaProvider = MoyaProvider<T>()
}

public extension Provider {
    func request<M: Decodable>(_ target: T, modelType: M.Type, completion: @escaping (Result<M, Error>) -> Void) {
        moyaProvider.request(target) { result in
            switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let model = try decoder.decode(M.self, from: response.data)
                        completion(.success(model))
                    }
                    catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func request(_ target: T, completion: @escaping (Result<(Int, Data), Error>) -> Void) {
        moyaProvider.request(target) { result in
            switch result {
                case .success(let response):
                    let statucCode = response.statusCode
                    let data = response.data
                    completion(.success((statucCode, data)))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
