//
//  ConfigurationModelTests.swift
//  stockdataTests
//
//  Created by Alvin Matthew Pratama on 28/12/20.
//

@testable import stockdata
import XCTest

class ConfigurationModelTests: XCTestCase {
    
    var configurationModel: ConfigurationModel!
    
    override func setUp() {
        super.setUp()
        configurationModel = ConfigurationModel()
    }
    
    override func tearDown() {
        super.tearDown()
        configurationModel = nil
    }
    
    func testSetDefaultParameters() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: K.UserDefaultKey.interval)
        defaults.removeObject(forKey: K.UserDefaultKey.outputsize)
        configurationModel.setDefaultParameters()
        
        XCTAssertEqual(configurationModel.getParameters().interval, "5min")
        XCTAssertEqual(configurationModel.getParameters().outputsize, "compact")
    }
    
    func testGetParameters() throws {
        let defaults = UserDefaults.standard
        let interval = defaults.object(forKey: K.UserDefaultKey.interval) as! String
        let outputsize = defaults.object(forKey: K.UserDefaultKey.outputsize) as! String
        let parameters = Parameter(interval: interval, outputsize: outputsize)
        
        XCTAssertEqual(configurationModel.getParameters().interval, parameters.interval)
        XCTAssertEqual(configurationModel.getParameters().outputsize, parameters.outputsize)
    }
    
    func testUpdateIntervalParameter() {
        configurationModel.updateParameter(interval: IntervalValue.the1min.rawValue)
        XCTAssertEqual(configurationModel.getParameters().interval, IntervalValue.the1min.rawValue)
    }
    
    func testUpdateOutputsizeParameter() {
        configurationModel.updateParameter(outputsize: OutputsizeValue.compact.rawValue)
        XCTAssertEqual(configurationModel.getParameters().outputsize, OutputsizeValue.compact.rawValue)
    }
    
    func testGetTimeSeriesKey() throws {
        let parameters = configurationModel.getParameters()
        let timeSeriesKey = "Time Series (\(parameters.interval))"
        
        XCTAssertEqual(configurationModel.getTimeSeriesKey(), timeSeriesKey)
    }
    
    func testSetDefaulAPIKey() throws {
        KeychainWrapper.standard.removeObject(forKey: K.KeyChainKey.apiKey)
        configurationModel.setDefaultAPIKey()
        
        XCTAssertEqual(configurationModel.getAPIKey(), "SINALNWR6553GGBL")
    }
    
    func testGetAPIKey() throws {
        let apiKey = KeychainWrapper.standard.string(forKey: K.KeyChainKey.apiKey)
        XCTAssertEqual(configurationModel.getAPIKey(), apiKey)
    }
    
    func testUpdateAPIKey() throws {
        configurationModel.updateAPIKey("APIKEY")
        XCTAssertEqual(configurationModel.getAPIKey(), "APIKEY")
    }
    
    func testCheckValidAPIKey() throws {
        XCTAssertNotNil(configurationModel.checkAPIKey("SINALNWR6553GGBL"))
    }
    
    func testCheckInvalidAPIKey() throws {
        XCTAssertNoThrow(configurationModel.checkAPIKey(""))
    }
}
