//
//  UserDefaults+.swift
//
//
//  Created by Wonwoo Choi on 5/7/24.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<Value> {
    private let key: String
    private let defaultValue: Value
    private let userDefaults = UserDefaults.standard
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get {
            return userDefaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefaults.removeObject(forKey: key)
            userDefaults.set(newValue, forKey: key)
            userDefaults.synchronize()
        }
    }
}

@propertyWrapper
public struct UserDefaultsObjectWrapper<Object: Codable> {
    private let key: String
    private let userDefaults = UserDefaults.standard
    
    public init(key: String) {
        self.key = key
    }
    
    public var wrappedValue: Object? {
        get {
            guard let data = userDefaults.data(forKey: key),
                  let object = try? JSONDecoder().decode(Object.self, from: data)
            else { return nil }
            
            return object
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue)
            else { return }
            
            userDefaults.set(data, forKey: key)
        }
    }
}

@propertyWrapper
public struct UserDefaultsEnumWrapper<Value: RawRepresentable> {
    private let key: String
    private let defaultValue: Value
    private let userDefaults = UserDefaults.standard
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get {
            guard let object = userDefaults.object(forKey: key),
                  let rawValue = object as? Value.RawValue,
                  let enumValue = Value(rawValue: rawValue)
            else { return defaultValue }
            
            return enumValue
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: key)
            userDefaults.synchronize()
        }
    }
}
