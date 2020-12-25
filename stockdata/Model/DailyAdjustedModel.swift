//
//  DailyAdjustedModel.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import Foundation

protocol DailyAdjustedModelDelegate {
    func didUpdateDailyAdjusted(_ dailyAdjustedModel: DailyAdjustedModel, dailyComparison: [DailyComparison])
    func didFailWithError(error: Error, errorMessage: String)
}

struct DailyAdjustedModel {
    
    let apiURL = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&apikey=SINALNWR6553GGBL"
    var delegate: DailyAdjustedModelDelegate?
    
    func fetchDailyAdjusted(symbol: String) {
        let urlString = "\(apiURL)&symbol=\(symbol)"
        performRequest(with: urlString)
    }
    
    func addDailyComparison(currentDailyComparison: [DailyComparison], newDailyComparison: [DailyComparison], numberOfSymbols: Int) -> [DailyComparison] {
        if numberOfSymbols > 1 {
            var mergedComparison: [DailyComparison] = currentDailyComparison
            for new in newDailyComparison {
                if let index = mergedComparison.firstIndex(where: { $0.date == new.date }) {
                    mergedComparison[index].timeSeries.append(contentsOf: new.timeSeries)
                }
            }
            return mergedComparison.sorted { $1.date < $0.date }
        }
        return newDailyComparison.sorted { $1.date < $0.date }
    }
    
    func removeDailyComparison(_ dailyComparison: [DailyComparison], symbol: String) -> [DailyComparison] {
        var updatedDailyComparison: [DailyComparison] = dailyComparison
        for (index, comparison) in updatedDailyComparison.enumerated() {
            if let serieIndex = comparison.timeSeries.firstIndex(where: { $0.symbol == symbol }) {
                updatedDailyComparison[index].timeSeries.remove(at: serieIndex)
            }
        }
        return updatedDailyComparison.sorted { $1.date < $0.date }
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
                    if let dailyComparison = self.parseJSON(safeData) {
                        self.delegate?.didUpdateDailyAdjusted(self, dailyComparison: dailyComparison)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    private func parseJSON(_ dailyAdjustedData: Data) -> [DailyComparison]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(DailyResponse.self, from: dailyAdjustedData)
            
            var dailyComparison: [DailyComparison] = []
            for (key, value) in decodedData.timeSeriesDaily {
                dailyComparison.append(DailyComparison(
                    date: key,
                    timeSeries: [DailyTimeSerie(symbol: decodedData.metaData.the2Symbol, open: value.the1Open, low: value.the3Low)]
                ))
            }
            
            return dailyComparison

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
