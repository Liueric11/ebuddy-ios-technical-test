//
//  ConfigManager.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

enum Environment: String {
    case development = "DevelopmentConfig"
    case staging = "StagingConfig"
}

class ConfigManager {
    static let shared = ConfigManager()
    var config: [String: Any] = [:]

    private init() {
        loadConfig()
    }

    private func loadConfig() {
        #if DEVELOPMENT
        let environment = Environment.development
        #else
        let environment = Environment.staging
        #endif

        if let url = Bundle.main.url(forResource: environment.rawValue, withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let configData = plist as? [String: Any] {
            self.config = configData
        } else {
            fatalError("Unable to load \(environment.rawValue).plist")
        }
    }

    func getValue(forKey key: String) -> String {
        return config[key] as? String ?? ""
    }
}
