//
//  IntradayModel.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import Foundation

protocol IntradayModelDelegate {
    func didUpdateIntraday(_ intradayModel: IntradayModel, intraday: Intraday)
    func didFailWithError(error: Error, errorMessage: String)
    func didFailWithoutError(errorMessage: String)
}

struct IntradayModel {
    let apiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY"
    var delegate: IntradayModelDelegate?
    
    func setupApiURL() -> String? {
        let configurationModel = ConfigurationModel()
        let parameters = configurationModel.getParameters()
        if let apiKey = configurationModel.getAPIKey() {
            return "\(apiURL)&interval=\(parameters.interval)&outputsize=\(parameters.outputsize)&apikey=\(apiKey)"
        } else {
            delegate?.didFailWithoutError(errorMessage: "Invalid API Key")
            return nil
        }
    }
    
    func fetchIntraday(symbol: String) {
        if let setupApiUrl = setupApiURL() {
            let urlString = "\(setupApiUrl)&symbol=\(symbol)"
            performRequest(with: urlString)
        }
    }
    
    func sort(by option: SortOption, timeSeries: [IntradayTimeSerie]) -> [IntradayTimeSerie] {
        
        var sortedTimeSeries: [IntradayTimeSerie] = []
        
        switch option {
        case SortOption.open:
            sortedTimeSeries = timeSeries.sorted { $1.open < $0.open }
        case SortOption.high:
            sortedTimeSeries = timeSeries.sorted { $1.high < $0.high }
        case SortOption.low:
            sortedTimeSeries = timeSeries.sorted { $1.low < $0.low }
        case SortOption.datetime:
            sortedTimeSeries = timeSeries.sorted { $1.datetime < $0.datetime }
        }
        
        return sortedTimeSeries
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!, errorMessage: errorHandle(error: error!))
                    return
                }
                if let safeData = data {
                    if let intraday = self.parseJSON(safeData) {
                        self.delegate?.didUpdateIntraday(self, intraday: intraday)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    private func parseJSON(_ intradayData: Data) -> Intraday? {
//        let decoder = JSONDecoder()
        
        do {
//            let decodedData = try decoder.decode(IntradayResponse.self, from: intradayData)
            
            var symbol: String = "--"
            var timeSeries: [IntradayTimeSerie] = []
            
            if let json = try JSONSerialization.jsonObject(with: intradayData, options: []) as? [String: Any] {
                if let metaData = json["Meta Data"] as? [String: Any] {
                    if let metaData = metaData as? Dictionary<String, String> {
                        symbol = metaData["2. Symbol"]!
                    } else {
                        DispatchQueue.main.async {
                            delegate?.didFailWithoutError(errorMessage: "Sorry we couldn't find the symbol you were looking for")
                            return
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        delegate?.didFailWithoutError(errorMessage: "Sorry we couldn't find the symbol you were looking for")
                        return
                    }
                }
                
                if let time = json[configurationModel.getTimeSeriesKey()] as? [String: Any] {
                    for (key, value) in time {
                        if let value = value as? Dictionary<String, String> {
                            timeSeries.append(IntradayTimeSerie(datetime: key, open: value["1. open"]!, high: value["2. high"]!, low: value["3. low"]!))
                        }
                    }
                }
            }
            let intraday = Intraday(symbol: symbol, timeSeries: timeSeries)
            return intraday

        } catch {
            DispatchQueue.main.async {
                delegate?.didFailWithError(error: error, errorMessage: errorHandle(error: error))
            }
            return nil
        }
    }
    
    private func errorHandle(error: Error) -> String {
        var errorMessage = "Sorry, something went wrong"
        
        errorMessage = error.localizedDescription
        
        return errorMessage
    }
}
