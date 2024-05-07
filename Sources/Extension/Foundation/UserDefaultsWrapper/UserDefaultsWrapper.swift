//
//  UserDefaults+.swift
//
//
//  Created by Wonwoo Choi on 5/7/24.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<Value> {
    let key: String
    let defaultValue: Value
    let userDefaults = UserDefaults.standard
    
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
    let key: String
    let userDefaults = UserDefaults.standard
    
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
    let key: String
    let defaultValue: Value
    let userDefaults = UserDefaults.standard
    
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
