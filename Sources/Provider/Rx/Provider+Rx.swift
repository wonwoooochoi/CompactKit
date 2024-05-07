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

public extension Provider {
    func request<M: Decodable>(_ target: T, modelType: M.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> Single<Result<ProviderModelResponse<M>, Error>> {
        ProviderPrint.printRequestDescription(target: target, printOption: printRequest)
        return Single<Result<ProviderModelResponse<M>, Error>>.create { single in
            let disposable = self.moyaProvider.rx
                .request(target)
                .subscribe(onSuccess: { response in
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = keyDecodingStrategy
                    
                    do {
                        ProviderPrint.printResponseDescription(target: target, response: response, printOption: self.printResponse)
                        let statusCode = response.statusCode
                        let model = try decoder.decode(M.self, from: response.data)
                        let providerResponse = ProviderModelResponse(statusCode: statusCode, model: model)
                        single(.success(.success(providerResponse)))
                    }
                    catch {
                        ProviderPrint.printErrorResponse(target: target, error: error, printOption: self.printRequest)
                        single(.success(.failure(error)))
                    }
                }, onFailure: { error in
                    ProviderPrint.printErrorResponse(target: target, error: error, printOption: self.printRequest)
                    single(.success(.failure(error)))
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func request(_ target: T) -> Single<Result<ProviderResponse, Error>> {
        ProviderPrint.printRequestDescription(target: target, printOption: printRequest)
        return Single<Result<ProviderResponse, Error>>.create { single in
            let disposable = self.moyaProvider.rx
                .request(target)
                .subscribe(onSuccess: { response in
                    ProviderPrint.printResponseDescription(target: target, response: response, printOption: self.printResponse)
                    let statusCode = response.statusCode
                    let data = response.data
                    let dataString = String(data: response.data, encoding: .utf8)
                    let providerResponse = ProviderResponse(statusCode: statusCode, data: data, dataString: dataString ?? "")
                    single(.success(.success(providerResponse)))
                }, onFailure: { error in
                    ProviderPrint.printErrorResponse(target: target, error: error, printOption: self.printRequest)
                    single(.success(.failure(error)))
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}
