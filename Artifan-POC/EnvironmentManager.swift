//
//  EnvironmentManager.swift
//  Artifan-POC
//
//  Created by Victor Castro on 12/08/24.
//

import Foundation

class EnvironmentManager {
    
    static let shared = EnvironmentManager()
    
    private init() {}
    
    func getValue(forKey key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
    
    var environmentURL: URL? {
        guard
            let urlDict = Bundle.main.object(forInfoDictionaryKey: "ENVIRONMENT_URL") as? [String: String],
            let scheme = urlDict["SCHEME"],
            let host = urlDict["HOST"] else {
            print("❌ Error: Parámetros de ENVIRONMENT_URL no están configurados correctamente")
            return nil
        }
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        
        if let portString = urlDict["PORT"], let port = Int(portString) {
            components.port = port
        }
        
        guard let url = components.url else {
            print("❌ Error: URL construida no válida")
            return nil
        }
        
        return url
    }
}
