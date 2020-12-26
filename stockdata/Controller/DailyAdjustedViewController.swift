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
    
    func showAlert(title: String = "Error", message: String) {
        let alertHelper = AlertHelper()
        let alert: UIAlertController = alertHelper.showAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:- UISearchBarDelegate

extension DailyAdjustedViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text! == "" {
            view.endEditing(true)
            return
        }
        if addedSymbols.count < 3 {
            if addedSymbols.firstIndex(of: searchBar.text!) != nil {
                showAlert(title: "Alert", message: "Symbol has been added")
            } else {
                dailyAdjustedModel.fetchDailyAdjusted(symbol: searchBar.text!.uppercased())
            }
        } else {
            showAlert(title: "Alert", message: "Maximum three symbols that can be compared at a time")
        }
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
        showAlert(message: errorMessage)
    }
    
    func didFailWithoutError(errorMessage: String) {
        showAlert(message: errorMessage)
    }
    
    func removeSymbol(_ symbol: String) {
        if let index = addedSymbols.firstIndex(of: symbol) {
            addedSymbols.remove(at: index)
            dailyComparisons = addedSymbols.count > 0 ? dailyAdjustedModel.removeDailyComparison(dailyComparisons, symbol: symbol) : []
            collectionView.reloadData()
            tableView.reloadData()
        }
    }
    
}

// MARK:- CollectionView DataSource, Delegate

extension DailyAdjustedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedSymbols.count > 0 ? addedSymbols.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Cell.symbolCollectionViewCell, for: indexPath) as! SymbolCollectionViewCell
        
        if addedSymbols.count > 0 {
            cell.symbolLabel.text = addedSymbols[indexPath.item]
            cell.closeImage.isHidden = false
        } else {
            cell.symbolLabel.text = "--"
            cell.closeImage.isHidden = true
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if addedSymbols.count > 0 {
            removeSymbol(addedSymbols[indexPath.row])
        }
    }
}

// MARK: - TableView DataSource, Delegate

extension DailyAdjustedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyComparisons.count > 0 ? dailyComparisons.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.comparisonTableViewCell, for: indexPath) as! ComparisonTableViewCell
        cell.selectionStyle = .none
        if dailyComparisons.count > 0 {
            cell.date = dailyComparisons[indexPath.row].date
            cell.timeSeries = dailyComparisons[indexPath.row].timeSeries
        } else {
            cell.date = "0000-00-00"
        }
        cell.itemTableView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 + (CGFloat(30 * addedSymbols.count))
    }
    
}
