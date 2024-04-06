//
//  Provider+Rx.swift
//  
//
//  Created by Wonwoo Choi on 4/7/24.
//

import Foundation
import RxSwift
import RxMoya
import Provider
import SwiftUI

public extension Provider {
    func request<M: Decodable>(_ target: T, modelType: M.Type) -> Single<Result<M, Error>> {
        return Single<Result<M, Error>>.create { single in
            let disposable = self.moyaProvider.rx
                .request(target)
                .subscribe(onSuccess: { response in
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        let model = try decoder.decode(M.self, from: response.data)
                        let success = Result<M, Error>.success(model)
                        single(.success(success))
                    }
                    catch {
                        single(.success(.failure(error)))
                    }
                }, onFailure: { error in
                    single(.success(.failure(error)))
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func request(_ target: T) -> Single<Result<(Int, Data), Error>> {
        return Single<Result<(Int, Data), Error>>.create { single in
            let disposable = self.moyaProvider.rx
                .request(target)
                .subscribe(onSuccess: { response in
                    let statucCode = response.statusCode
                    let data = response.data
                    single(.success(.success((statucCode, data))))
                }, onFailure: { error in
                    single(.success(.failure(error)))
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}
