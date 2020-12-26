//
//  Enum.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

enum SortOption {
    case open, high, low, datetime
}

enum IntervalValue: String, CaseIterable {
    case the1min = "1min", the5min = "5min", the15min = "15min", the30min = "30min", the60min = "60min"
}

enum OutputsizeValue: String, CaseIterable {
    case compact = "compact", full = "full"
}
