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

struct ConfigurationModel {
    
    let defaults = UserDefaults.standard
    
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
    
}
