//
//  Constant.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

struct K {
    struct Cell {
        static let intradayTableViewCell = "IntradayTableViewCell"
        static let symbolCollectionViewCell = "SymbolCollectionViewCell"
        static let comparisonTableViewCell = "ComparisonTableViewCell"
        static let comparisonItemTableViewCell = "ComparisonItemTableViewCell"
        static let pickerViewTableViewCell = "PickerViewTableViewCell"
    }
    
    struct Color {
        static let blue = "Blue"
        static let red = "Red"
        static let green = "Green"
        static let grey = "Grey"
    }
    
    struct Segue {
        static let configurationToEditAPIKey = "ConfigurationToEditAPIKey"
    }
    
    struct UserDefaultKey {
        static let interval = "interval"
        static let outputsize = "outputsize"
    }
}
