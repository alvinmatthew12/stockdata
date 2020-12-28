//
//  DailyAdjustedModelTests.swift
//  stockdataTests
//
//  Created by Alvin Matthew Pratama on 28/12/20.
//

@testable import stockdata
import XCTest

class DailyAdjustedModelTests: XCTestCase {
    
    var dailyModel: DailyAdjustedModel!
    
    override func setUp() {
        super.setUp()
        dailyModel = DailyAdjustedModel()
    }
    
    override func tearDown() {
        super.tearDown()
        dailyModel = nil
    }
    
    
    func testSetupApiURL() throws {
        var apiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED"
        let configurationModel = ConfigurationModel()
        let parameters = configurationModel.getParameters()
        if let apiKey = configurationModel.getAPIKey() {
            apiURL = "\(apiURL)&outputsize=\(parameters.outputsize)&apikey=\(apiKey)"
        }
        XCTAssertEqual(dailyModel.setupApiURL(), apiURL)
    }
    
    func testFetchDailyAdjusted() throws {
        XCTAssertNotNil(dailyModel.fetchDailyAdjusted(symbol: "AIA"))
    }
    
    func testAddDailyComparison() throws {
        let dailyComparison = [
            DailyComparison(date: "2020-12-24", timeSeries: [
                DailyTimeSerie(symbol: "IBM", open: "125.0", low: "124.21")
            ])
        ]
        let newDailyComparison = [
            DailyComparison(date: "2020-12-24", timeSeries: [
                DailyTimeSerie(symbol: "AIA", open: "84.36", low: "83.75")
            ])
        ]
        let mergedDailyComparison = [
            DailyComparison(date: "2020-12-24", timeSeries: [
                DailyTimeSerie(symbol: "IBM", open: "125.0", low: "124.21"),
                DailyTimeSerie(symbol: "AIA", open: "84.36", low: "83.75")
            ])
        ]
        
        XCTAssertEqual(dailyModel.addDailyComparison(currentDailyComparison: dailyComparison, newDailyComparison: newDailyComparison, numberOfSymbols: 2)[0].timeSeries[0].symbol, mergedDailyComparison[0].timeSeries[0].symbol)
        XCTAssertEqual(dailyModel.addDailyComparison(currentDailyComparison: dailyComparison, newDailyComparison: newDailyComparison, numberOfSymbols: 2)[0].timeSeries[1].symbol, mergedDailyComparison[0].timeSeries[1].symbol)
    }
    
    func testRemoveDailyComparison() throws {
        let dailyComparison = [
            DailyComparison(date: "2020-12-24", timeSeries: [
                DailyTimeSerie(symbol: "IBM", open: "125.0", low: "124.21"),
                DailyTimeSerie(symbol: "AIA", open: "84.36", low: "83.75")
            ])
        ]
        let updatedDailyComparison = [
            DailyComparison(date: "2020-12-24", timeSeries: [
                DailyTimeSerie(symbol: "IBM", open: "125.0", low: "124.21")
            ])
        ]
        XCTAssertEqual(dailyModel.removeDailyComparison(dailyComparison, symbol: "AIA")[0].timeSeries.count, updatedDailyComparison[0].timeSeries.count)
        XCTAssertEqual(dailyModel.removeDailyComparison(dailyComparison, symbol: "AIA")[0].timeSeries[0].symbol, updatedDailyComparison[0].timeSeries[0].symbol)
        XCTAssertNotEqual(dailyModel.removeDailyComparison(dailyComparison, symbol: "IBM")[0].timeSeries[0].symbol, updatedDailyComparison[0].timeSeries[0].symbol)
    }
    
}
