//
//  DailyAdjustmentData.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import Foundation

struct DailyAdjustment {
    let date: String
    let timeSeries: [DailyTimeSerie]
}

struct DailyTimeSerie {
    let symbol: String
    let open: String
    let low: String
}
