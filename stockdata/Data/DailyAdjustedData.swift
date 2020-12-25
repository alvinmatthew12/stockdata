//
//  DailyAdjustedData.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import Foundation

struct DailyResponse: Codable {
    let metaData: DailyMetaData
    let timeSeriesDaily: [String: TimeSeriesDaily]

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

struct DailyMetaData: Codable {
    let the1Information, the2Symbol, the3LastRefreshed, the4OutputSize, the5TimeZone: String

    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4OutputSize = "4. Output Size"
        case the5TimeZone = "5. Time Zone"
    }
}

struct TimeSeriesDaily: Codable {
    let the1Open, the2High, the3Low, the4Close, the5AdjustedClose, the6Volume, the7DividendAmount, the8SplitCoefficient: String

    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
        case the2High = "2. high"
        case the3Low = "3. low"
        case the4Close = "4. close"
        case the5AdjustedClose = "5. adjusted close"
        case the6Volume = "6. volume"
        case the7DividendAmount = "7. dividend amount"
        case the8SplitCoefficient = "8. split coefficient"
    }
}

struct DailyComparison {
    let date: String
    let timeSeries: [DailyTimeSerie]
}

struct DailyTimeSerie {
    let symbol: String
    let open: String
    let low: String
}
