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
}

struct IntradayModel {
    let apiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&apikey=SINALNWR6553GGBL"
    var delegate: IntradayModelDelegate?
    
    func setApiURL() -> String {
        let configurationModel = ConfigurationModel()
        let parameters = configurationModel.getParameters()
        return "\(apiURL)&interval=\(parameters.interval)&outputsize=\(parameters.outputsize)"
    }
    
    func fetchIntraday(symbol: String) {
        let urlString = "\(setApiURL())&symbol=\(symbol)"
        performRequest(with: urlString)
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
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(IntradayResponse.self, from: intradayData)
            
            let symbol = decodedData.metaData.the2Symbol
            var timeSeries: [IntradayTimeSerie] = []
            for (key, value) in decodedData.timeSeries5Min {
                timeSeries.append(IntradayTimeSerie(datetime: key, open: value.the1Open, high: value.the2High, low: value.the3Low))
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
        
        if error.localizedDescription == "The data couldn’t be read because it is missing." {
            errorMessage = "Sorry, we couldn't find the symbol"
        }
        
        return errorMessage
    }
}
