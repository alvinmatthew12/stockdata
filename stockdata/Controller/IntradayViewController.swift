//
//  IntradayViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import UIKit

class IntradayViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var intradayModel = IntradayModel()
    var timeSeries: [IntradayTimeSerie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Intraday Data"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAnywhere()
        
        symbolLabel.text = "--"
        sortButton.isHidden = timeSeries.count > 0 ? false : true
        
        intradayModel.delegate = self
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.Cell.intradayTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cell.intradayTableViewCell)
    }
    
    @IBAction func sortByPressed(_ sender: UIButton) {
        showSortByActionSheet()
    }
    
    func showErrorAlert(message: String) {
        let alertHelper = AlertHelper()
        let alert: UIAlertController = alertHelper.showAlert(title: "Error", message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Sort by
    
    func showSortByActionSheet() {
        let actionSheet = UIAlertController(title: "Sort by", message: "Choose an option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Open", style: .default, handler: { (UIAlertAction) in  self.sort(by: SortOption.open) }))
        actionSheet.addAction(UIAlertAction(title: "High", style: .default, handler: { (UIAlertAction) in  self.sort(by: SortOption.high) }))
        actionSheet.addAction(UIAlertAction(title: "Low", style: .default, handler: { (UIAlertAction) in  self.sort(by: SortOption.low) }))
        actionSheet.addAction(UIAlertAction(title: "Date & Time", style: .default, handler: { (UIAlertAction) in  self.sort(by: SortOption.datetime) }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func sort(by value: SortOption) {
        timeSeries = intradayModel.sort(by: value, timeSeries: timeSeries)
        sortButton.setTitle("sort by: \(value)", for: .normal)
        tableView.reloadData()
    }
    
}

// MARK:- UISearchBarDelegate

extension IntradayViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.loadingStart()
        intradayModel.fetchIntraday(symbol: searchBar.text!.uppercased())
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


// MARK:- IntradayModelDelegate

extension IntradayViewController: IntradayModelDelegate {
    
    func didUpdateIntraday(_ intradayModel: IntradayModel, intraday: Intraday) {
        DispatchQueue.main.async { [self] in
            symbolLabel.text = intraday.symbol
            timeSeries = intraday.timeSeries
            sortButton.isHidden = false
            sortButton.setTitle("sort by", for: .normal)
            tableView.reloadData()
            self.loadingStop()
        }
    }
    
    func didFailWithError(error: Error, errorMessage: String) {
        self.loadingStop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.showErrorAlert(message: errorMessage)
        })
    }
    
    func didFailWithoutError(errorMessage: String) {
        self.loadingStop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.showErrorAlert(message: errorMessage)
        })
    }
}

// MARK:- TableView DataSource, Delegage

extension IntradayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSeries.count > 0 ? timeSeries.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.intradayTableViewCell, for: indexPath) as! IntradayTableViewCell
        cell.selectionStyle = .none
        
        if timeSeries.count > 0 {
            cell.openValueLabel.text = timeSeries[indexPath.row].open
            cell.highValueLabel.text = timeSeries[indexPath.row].high
            cell.lowValueLabel.text = timeSeries[indexPath.row].low
            cell.datetimeLabel.text = timeSeries[indexPath.row].datetime
        } else {
            cell.resetLabelText()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
