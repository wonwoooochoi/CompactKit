//
//  Provider.swift
//
//
//  Created by Wonwoo Choi on 4/6/24.
//

import Foundation
import Moya

public typealias TargetType = Moya.TargetType
public typealias Method = Moya.Method
public typealias Task = Moya.Task
public typealias ParameterEncoding = Moya.ParameterEncoding
public typealias JSONEncoding = Moya.JSONEncoding
public typealias URLEncoding = Moya.URLEncoding

final public class Provider<T: TargetType> {
    public enum PrintOption {
        case disable
        case endPoint
        case endPointAndParameters
    }
    
    public var printRequest: PrintOption = .endPointAndParameters
    public var printResponse: PrintOption = .endPointAndParameters
    public let moyaProvider = MoyaProvider<T>()
    public init() {}
}

public extension Provider {
    func request<M: Decodable>(_ target: T, modelType: M.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase, completion: @escaping (Result<ProviderModelResponse<M>, Error>) -> Void) {
        ProviderPrint.printRequestDescription(target: target, printOption: printRequest)
        
        moyaProvider.request(target) { result in
            switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = keyDecodingStrategy
                    
                    do {
                        ProviderPrint.printResponseDescription(target: target, response: response, printOption: self.printResponse)
                        let statusCode = response.statusCode
                        let model = try decoder.decode(M.self, from: response.data)
                        let providerResponse = ProviderModelResponse(statusCode: statusCode, model: model)
                        completion(.success(providerResponse))
                    } catch {
                        ProviderPrint.printErrorResponse(target: target, error: error, printOption: self.printRequest)
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    ProviderPrint.printErrorResponse(target: target, error: error, printOption: self.printRequest)
                    completion(.failure(error))
            }
        }
    }
    
    func request(_ target: T, completion: @escaping (Result<ProviderResponse, Error>) -> Void) {
        ProviderPrint.printRequestDescription(target: target, printOption: printRequest)

        moyaProvider.request(target) { result in
            switch result {
                case .success(let response):
                    ProviderPrint.printResponseDescription(target: target, response: response, printOption: self.printResponse)
                    let statusCode = response.statusCode
                    let data = response.data
                    let dataString = String(data: response.data, encoding: .utf8)
                    let providerResponse = ProviderResponse(statusCode: statusCode, data: data, dataString: dataString ?? "")
                    completion(.success(providerResponse))
                    
                case .failure(let error):
                    ProviderPrint.printErrorResponse(target: target, error: error, printOption: self.printRequest)
                    completion(.failure(error))
            }
        }
    }
}


public struct ProviderResponse {
    public let statusCode: Int
    public let data: Data
    public let dataString: String
    
    public init(statusCode: Int, data: Data, dataString: String) {
        self.statusCode = statusCode
        self.data = data
        self.dataString = dataString
    }
}

public struct ProviderModelResponse<M: Decodable> {
    public let statusCode: Int
    public let model: M
    
    public init(statusCode: Int, model: M) {
        self.statusCode = statusCode
        self.model = model
    }
}

public struct ProviderPrint {
    public static func printRequestDescription<T: TargetType>(target: T, withHeaders: Bool = false, printOption: Provider<T>.PrintOption) {
        guard printOption != .disable
        else { return }
        
        let endPoint = "\(target.method.rawValue) \(target.baseURL)/\(target.path)"
        var description = "[REQUEST | \(endPoint)]:"
        
        guard printOption == .endPointAndParameters
        else {
            print(description)
            return
        }
        
        if withHeaders,
           let headers = target.headers,
           !headers.isEmpty,
           let data = try? JSONSerialization.data(withJSONObject: headers, options: [.prettyPrinted]),
           let string = String(data: data, encoding: .utf8) {
            description += "\n\(string)"
        }
        
        if case .requestParameters(let parameters, _) = target.task,
           let data = try? JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted]),
           let string = String(data: data, encoding: .utf8) {
            description += "\n\(string)"
        } else {
            description += "\n\(target.task)"
        }
        
        print(description)
    }
    
    public static func printResponseDescription<T: TargetType>(target: T, response: Moya.Response, printOption: Provider<T>.PrintOption) {
        guard printOption != .disable
        else { return }
        
        let endPoint = "\(target.method.rawValue) \(target.baseURL)/\(target.path)"
        var description = "[RESPONSE | \(endPoint)]:"
        let data = response.data
        
        guard printOption == .endPointAndParameters
        else {
            print(description)
            return
        }
        
        if let object = try? JSONSerialization.jsonObject(with: data, options: []),
           let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
           let string = String(data: data, encoding: .utf8) {
            description += "\n\(string)"
        } else {
            description += "\n\(target.task)"
        }
        
        print(description)
    }
    
    public static func printErrorResponse<T: TargetType>(target: T, error: Error, printOption: Provider<T>.PrintOption) {
        guard printOption != .disable
        else { return }
        
        let endPoint = "\(target.method.rawValue) \(target.baseURL)/\(target.path)"
        var description = "[RESPONSE | \(endPoint)]:"
        
        guard printOption == .endPointAndParameters
        else {
            print(description)
            return
        }
        
        description += "\n\(error.localizedDescription)"
        
        print(description)
    }
}
