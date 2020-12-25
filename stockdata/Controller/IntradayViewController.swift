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
    var timeSeries: [TimeSerie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Intraday Data"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAnywhere()
        
        symbolLabel.isHidden = timeSeries.count > 0 ? false : true
        sortButton.isHidden = timeSeries.count > 0 ? false : true
        
        intradayModel.delegate = self
        intradayModel.fetchIntraday(symbol: "AIA")
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.Cell.intradayTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cell.intradayTableViewCell)
    }
    
    @IBAction func sortByPressed(_ sender: UIButton) {
        showSortByActionSheet()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        intradayModel.fetchIntraday(symbol: searchBar.text!.uppercased())
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            intradayModel.fetchIntraday(symbol: "AIA")
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
            symbolLabel.isHidden = false
            sortButton.isHidden = false
            tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK:- TableView DataSource, Delegage

extension IntradayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.intradayTableViewCell, for: indexPath) as! IntradayTableViewCell
        cell.selectionStyle = .none
        cell.openValueLabel.text = timeSeries[indexPath.row].open
        cell.highValueLabel.text = timeSeries[indexPath.row].high
        cell.lowValueLabel.text = timeSeries[indexPath.row].low
        cell.datetimeLabel.text = timeSeries[indexPath.row].datetime
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
