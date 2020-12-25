//
//  IntradayModel.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import Foundation

protocol IntradayModelDelegate {
    func didUpdateIntraday(_ intradayModel: IntradayModel, intraday: Intraday)
    func didFailWithError(error: Error)
}

struct IntradayModel {
    let apiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&interval=5min&apikey=SINALNWR6553GGBL"
    var delegate: IntradayModelDelegate?
    
    func fetchIntraday(symbol: String) {
        let urlString = "\(apiURL)&symbol=\(symbol)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
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
            var timeSeries: [TimeSerie] = []
            for (key, value) in decodedData.timeSeries5Min {
                timeSeries.append(TimeSerie(datetime: key, open: value.the1Open, high: value.the2High, low: value.the3Low))
            }
            
            let intraday = Intraday(symbol: symbol, timeSeries: timeSeries)
            return intraday

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
