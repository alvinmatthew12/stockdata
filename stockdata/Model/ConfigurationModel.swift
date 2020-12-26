//
//  ConfigurationModel.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 27/12/20.
//

import Foundation

struct Parameter {
    let interval: String
    let outputsize: String
}

protocol ConfigurationModelDelegate {
    func didCheckAPIKey(isValid: Bool)
}

struct ConfigurationModel {
    
    let defaults = UserDefaults.standard
    var delegate: ConfigurationModelDelegate?
    
    func setDefaultParameters() {
        if defaults.object(forKey: K.UserDefaultKey.interval) == nil {
            defaults.setValue(IntervalValue.the5min.rawValue, forKey: K.UserDefaultKey.interval)
        }
        if defaults.object(forKey: K.UserDefaultKey.outputsize) == nil {
            defaults.setValue(OutputsizeValue.compact.rawValue, forKey: K.UserDefaultKey.outputsize)
        }
    }
    
    func getParameters() -> Parameter {
        let interval = defaults.object(forKey: K.UserDefaultKey.interval) as! String
        let outputsize = defaults.object(forKey: K.UserDefaultKey.outputsize) as! String
        return Parameter(interval: interval, outputsize: outputsize)
    }
    
    func updateParameter(interval value: String) {
        defaults.setValue(value, forKey: K.UserDefaultKey.interval)
    }
    
    func updateParameter(outputsize value: String) {
        defaults.setValue(value, forKey: K.UserDefaultKey.outputsize)
    }
    
    func setDefaultAPIKey() {
        if !KeychainWrapper.standard.hasValue(forKey: K.KeyChainKey.apiKey) {
            KeychainWrapper.standard.set("SINALNWR6553GGBL", forKey: K.KeyChainKey.apiKey)
        }
    }
    
    func updateAPIKey(_ value: String) {
        KeychainWrapper.standard.set(value, forKey: K.KeyChainKey.apiKey)
    }
    
    func getAPIKey() -> String? {
        if let apiKey = KeychainWrapper.standard.string(forKey: K.KeyChainKey.apiKey) {
            return apiKey
        }
        return nil
    }
    
    func checkAPIKey(_ apiKey: String) {
        let apiUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=IBM&apikey=\(apiKey)"
        if let url = URL(string: apiUrl) {
            URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didCheckAPIKey(isValid: false)
                    return
                }
                delegate?.didCheckAPIKey(isValid: true)
                return
            }.resume()
        }
    }
    
}
