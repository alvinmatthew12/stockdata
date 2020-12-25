//
//  ComparisonTableViewCell.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import UIKit

class ComparisonTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var itemTableView: UITableView!
    
    var date: String = "0000-00-00"
    var timeSeries: [DailyTimeSerie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.addBorder(radius: 12)
        
        itemTableView.dataSource = self
        itemTableView.delegate = self
        
        itemTableView.register(UINib(nibName: K.Cell.comparisonItemTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cell.comparisonItemTableViewCell)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSeries.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell.comparisonItemTableViewCell, for: indexPath) as! ComparisonItemTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row == 0 { // header
            cell.label1.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.4).isActive = true
            cell.label2.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.2).isActive = true
            cell.label3.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.4).isActive = true
            
            cell.label1.text = date
            cell.label1.textColor = UIColor(named: K.Color.grey)
            cell.label2.text = "Open"
            cell.label2.textColor = UIColor(named: K.Color.blue)
            cell.label3.text = "Low"
            cell.label3.textColor = UIColor(named: K.Color.blue)
        } else { // body
            switch indexPath.row {
            case 2:
                cell.label1.textColor = UIColor(named: K.Color.red)
            case 3:
                cell.label1.textColor = UIColor(named: K.Color.green)
            default:
                cell.label1.textColor = UIColor(named: K.Color.blue)
            }
            
            cell.label1.font = UIFont.boldSystemFont(ofSize: 15)
            cell.label2.font = UIFont.boldSystemFont(ofSize: 15)
            cell.label3.font = UIFont.boldSystemFont(ofSize: 15)
            cell.label1.text = timeSeries[indexPath.row - 1].symbol
            cell.label2.text = timeSeries[indexPath.row - 1].open
            cell.label3.text = timeSeries[indexPath.row - 1].low
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        return 30
    }
    
}

class ComparisonItemTableViewCell: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
}
