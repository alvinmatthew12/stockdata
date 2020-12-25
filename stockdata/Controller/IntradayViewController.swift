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
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Intraday Data"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        actionSheet.addAction(UIAlertAction(title: "Open", style: .default, handler: { (UIAlertAction) in  self.sort(by: "open") }))
        actionSheet.addAction(UIAlertAction(title: "High", style: .default, handler: { (UIAlertAction) in  self.sort(by: "high") }))
        actionSheet.addAction(UIAlertAction(title: "Low", style: .default, handler: { (UIAlertAction) in  self.sort(by: "low") }))
        actionSheet.addAction(UIAlertAction(title: "Date & Time", style: .default, handler: { (UIAlertAction) in  self.sort(by: "datetime") }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func sort(by value: String) {
        sortButton.setTitle("sort by: \(value)", for: .normal)
    }
    
}

// MARK:- TableView DataSource, Delegage

extension IntradayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.intradayTableViewCell, for: indexPath) as! IntradayTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
