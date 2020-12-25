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
    
    var dailyAdjustedModel = DailyAdjustedModel()
    
    var addedSymbols: [String] = []
    var dailyComparisons: [DailyComparison] = []
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Daily Adjusted Data"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.hideKeyboardWhenTappedAnywhere()
        
        dailyAdjustedModel.delegate = self
        dailyAdjustedModel.fetchDailyAdjusted(symbol: "AIA")
        
        searchBar.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: K.Cell.symbolCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: K.Cell.symbolCollectionViewCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.Cell.comparisonTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cell.comparisonTableViewCell)
    }

}

// MARK:- UISearchBarDelegate

extension DailyAdjustedViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dailyAdjustedModel.fetchDailyAdjusted(symbol: searchBar.text!.uppercased())
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK:- DailyAdjustedModelDelegate, Manipulate Data

extension DailyAdjustedViewController: DailyAdjustedModelDelegate {
    func didUpdateDailyAdjusted(_ dailyAdjustedModel: DailyAdjustedModel, dailyComparison: [DailyComparison]) {
        DispatchQueue.main.async { [self] in
            addedSymbols.append(dailyComparison[0].timeSeries[0].symbol)
            dailyComparisons = dailyAdjustedModel.addDailyComparison(currentDailyComparison: dailyComparisons, newDailyComparison: dailyComparison, numberOfSymbols: addedSymbols.count)
            collectionView.reloadData()
            tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        print(error)
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
        return dailyComparisons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.comparisonTableViewCell, for: indexPath) as! ComparisonTableViewCell
        cell.selectionStyle = .none
        cell.date = dailyComparisons[indexPath.row].date
        cell.timeSeries = dailyComparisons[indexPath.row].timeSeries
        cell.itemTableView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + (CGFloat(30 * addedSymbols.count))
    }
    
}
