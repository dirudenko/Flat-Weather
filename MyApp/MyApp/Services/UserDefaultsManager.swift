//
//  UserDefaultsManager.swift
//  MyApp
//
//  Created by Dmitry on 10.01.2022.
//

import Foundation
/// менеджер для хранения пользовательских типов данных
struct UserDefaultsManager {
    static var userDefaults: UserDefaults = .standard
    
    static func set<T>(_ value: T, forKey: String) where T: Encodable {
        if let encoded = try? JSONEncoder().encode(value) {
            userDefaults.set(encoded, forKey: forKey)
        }
    }
    
    static func get<T>(forKey: String) -> T? where T: Decodable {
        guard let data = userDefaults.value(forKey: forKey) as? Data,
            let decodedData = try? JSONDecoder().decode(T.self, from: data)
            else { return nil }
        return decodedData
    }
}
