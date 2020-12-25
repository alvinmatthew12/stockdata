//
//  DailyAdjustedViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import UIKit

class DailyAdjustedViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var addedSymbols: [String] = ["AIA", "AAPL", "IBM"]
    var dailyAdjustedData: [DailyComparison] = [
        DailyComparison(
            date: "2020-12-24",
            timeSeries: [
                DailyTimeSerie(symbol: "AIA", open: "84.0000", low: "84.0000"),
                DailyTimeSerie(symbol: "AAPL", open: "84.0000", low: "124.21"),
                DailyTimeSerie(symbol: "IBM", open: "84.0000", low: "84.0000"),
            ]
        ),
        DailyComparison(
            date: "2020-12-23",
            timeSeries: [
                DailyTimeSerie(symbol: "AIA", open: "84.0000", low: "84.0000"),
                DailyTimeSerie(symbol: "AAPL", open: "84.0000", low: "84.0000"),
                DailyTimeSerie(symbol: "IBM", open: "84.0000", low: "124.21"),
            ]
        ),
        DailyComparison(
            date: "2020-12-22",
            timeSeries: [
                DailyTimeSerie(symbol: "AIA", open: "84.0000", low: "124.21"),
                DailyTimeSerie(symbol: "AAPL", open: "84.0000", low: "84.0000"),
                DailyTimeSerie(symbol: "IBM", open: "84.0000", low: "84.0000"),
            ]
        ),
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Daily Adjusted Data"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAnywhere()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: K.Cell.symbolCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: K.Cell.symbolCollectionViewCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.Cell.comparisonTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cell.comparisonTableViewCell)
    }

}

// MARK:- CollectionView DataSource, Delegate

extension DailyAdjustedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedSymbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.symbolCollectionViewCell, for: indexPath) as! SymbolCollectionViewCell
        
        cell.symbolLabel.text = addedSymbols[indexPath.item]
        
        switch indexPath.item {
        case 1:
            cell.cardView.backgroundColor = UIColor(named: K.Color.red)
        case 2:
            cell.cardView.backgroundColor = UIColor(named: K.Color.green)
        default:
            cell.cardView.backgroundColor = UIColor(named: K.Color.blue)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 40)
    }
}

// MARK: - TableView DataSource, Delegate

extension DailyAdjustedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyAdjustedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.comparisonTableViewCell, for: indexPath) as! ComparisonTableViewCell
        cell.selectionStyle = .none
        cell.date = dailyAdjustedData[indexPath.row].date
        cell.timeSeries = dailyAdjustedData[indexPath.row].timeSeries
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + (CGFloat(30 * addedSymbols.count))
    }
    
}
