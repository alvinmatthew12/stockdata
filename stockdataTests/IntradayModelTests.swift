//
//  IntradayModelTests.swift
//  stockdataTests
//
//  Created by Alvin Matthew Pratama on 28/12/20.
//

@testable import stockdata
import XCTest


class IntradayModelTests: XCTestCase {

    var intradayModel: IntradayModel!
    
    override func setUp() {
        super.setUp()
        intradayModel = IntradayModel()
    }
    
    override func tearDown() {
        super.tearDown()
        intradayModel = nil
    }
    
    func testSetupApiURL() throws {
        var apiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY"
        let configurationModel = ConfigurationModel()
        let parameters = configurationModel.getParameters()
        if let apiKey = configurationModel.getAPIKey() {
            apiURL = "\(apiURL)&interval=\(parameters.interval)&outputsize=\(parameters.outputsize)&apikey=\(apiKey)"
        }
        XCTAssertEqual(intradayModel.setupApiURL(), apiURL)
    }
    
    func testFetchIntradayWithValidSymbol() throws {
        XCTAssertNotNil(intradayModel.fetchIntraday(symbol: "AIA"))
    }
    
    func testFetchIntradayWithInvalidSymbol() throws {
        XCTAssertNoThrow(intradayModel.fetchIntraday(symbol: ""))
    }
    
    func testSortIntradayWithOpen() throws {
        let timeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        let sortedTimeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        XCTAssertEqual(intradayModel.sort(by: SortOption.open, timeSeries: timeSeries)[0].open, sortedTimeSeries[0].open)
    }
    
    func testSortIntradayWithHigh() throws {
        let timeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        let sortedTimeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
        ]
        XCTAssertEqual(intradayModel.sort(by: SortOption.high, timeSeries: timeSeries)[0].high, sortedTimeSeries[0].high)
    }
    
    func testSortIntradayWithLow() throws {
        let timeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        let sortedTimeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        XCTAssertEqual(intradayModel.sort(by: SortOption.low, timeSeries: timeSeries)[0].low, sortedTimeSeries[0].low)
    }
    
    func testSortIntradayWithDatetime() throws {
        let timeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        let sortedTimeSeries = [
            IntradayTimeSerie(datetime: "2020-12-24 13:05:00", open: "84.0000", high: "84.0000", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 13:00:00", open: "84.0300", high: "84.0700", low: "84.0000"),
            IntradayTimeSerie(datetime: "2020-12-24 12:55:00", open: "83.9900", high: "84.0600", low: "83.9900"),
        ]
        XCTAssertEqual(intradayModel.sort(by: SortOption.datetime, timeSeries: timeSeries)[0].datetime, sortedTimeSeries[0].datetime)
    }
}
