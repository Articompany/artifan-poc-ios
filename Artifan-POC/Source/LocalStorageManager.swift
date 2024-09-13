//
//  LocalStorageManager.swift
//  Artifan-POC
//
//  Created by Victor Castro on 17/08/24.
//

import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()
    
    private init() {}
    
    func set<T>(_ value: T, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get<T>(forKey key: String, defaultValue: T) -> T {
        return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    
    func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func setObject<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func getObject<T: Codable>(forKey key: String, defaultValue: T) -> T {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: data) {
                return decoded
            }
        }
        return defaultValue
    }
    
    func resetAll() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
