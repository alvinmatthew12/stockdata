//
//  ConfigurationViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import UIKit

class ConfigurationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let intervalValueLabel = UILabel()
    let outputsizeValueLabel = UILabel()
    
    var tableHeaders: [String] = ["API Key", "Parameters"]
    var tableContents: [[String]] = [ ["api"], ["space", "interval", "intervalPicker", "outputsize", "outputsizePicker", "space"] ]
    
    var intervalValue: String = ""
    var outputsizeValue: String = ""
    
    var showIntervalPicker: Bool = false
    var showOutputsizePicker: Bool = false
    
    let configurationModel = ConfigurationModel()
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Configuration"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.Cell.pickerViewTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cell.pickerViewTableViewCell)
        
        let parameters = configurationModel.getParameters()
        intervalValue = parameters.interval
        outputsizeValue = parameters.outputsize
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableContents.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < tableHeaders.count {
            return tableHeaders[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableContents[indexPath.section][indexPath.row] == "api" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "SINALNWR6553GGBL"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if tableContents[indexPath.section][indexPath.row] == "interval" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Interval"
            intervalValueLabel.textColor = UIColor(named: K.Color.grey)
            intervalValueLabel.text = intervalValue
            cell.addSubview(intervalValueLabel)
            intervalValueLabel.translatesAutoresizingMaskIntoConstraints = false
            intervalValueLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15).isActive = true
            intervalValueLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            return cell
        }
        if tableContents[indexPath.section][indexPath.row] == "outputsize" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Outputsize"
            outputsizeValueLabel.textColor = UIColor(named: K.Color.grey)
            outputsizeValueLabel.text = outputsizeValue
            cell.addSubview(outputsizeValueLabel)
            outputsizeValueLabel.translatesAutoresizingMaskIntoConstraints = false
            outputsizeValueLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15).isActive = true
            outputsizeValueLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            return cell
        }
        if tableContents[indexPath.section][indexPath.row] == "intervalPicker" {
            let pickerCell = tableView.dequeueReusableCell(withIdentifier: K.Cell.pickerViewTableViewCell, for: indexPath) as! PickerViewTableViewCell
            pickerCell.delegate = self
            pickerCell.key = "interval"
            for value in IntervalValue.allCases {
                pickerCell.items.append(value.rawValue)
            }
            pickerCell.selectedItem = intervalValue
            return pickerCell
        }
        if tableContents[indexPath.section][indexPath.row] == "outputsizePicker" {
            let pickerCell = tableView.dequeueReusableCell(withIdentifier: K.Cell.pickerViewTableViewCell, for: indexPath) as! PickerViewTableViewCell
            pickerCell.delegate = self
            pickerCell.key = "outputsize"
            for value in OutputsizeValue.allCases {
                pickerCell.items.append(value.rawValue)
            }
            pickerCell.selectedItem = outputsizeValue
            return pickerCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableContents[indexPath.section][indexPath.row] == "api" {
            performSegue(withIdentifier: K.Segue.configurationToEditAPIKey, sender: self)
        }
        if tableContents[indexPath.section][indexPath.row] == "interval" {
            showIntervalPicker = !showIntervalPicker
            showOutputsizePicker = false
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if tableContents[indexPath.section][indexPath.row] == "outputsize" {
            showOutputsizePicker = !showOutputsizePicker
            showIntervalPicker = false
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableContents[indexPath.section][indexPath.row] == "intervalPicker" {
            return showIntervalPicker && !showOutputsizePicker ? 150 : 0
        }
        if tableContents[indexPath.section][indexPath.row] == "outputsizePicker"  {
            return showOutputsizePicker && !showIntervalPicker ? 150 : 0
        }
        if tableContents[indexPath.section][indexPath.row] == "space" {
            return 10
        }
        return 43.5
    }
}

extension ConfigurationViewController: PickerViewTableViewCellDelegate {
    func didSelectItem(key: String, value: String) {
        if key == "interval" {
            intervalValue = value
            configurationModel.updateParameter(interval: value)
        } else {
            outputsizeValue = value
            configurationModel.updateParameter(outputsize: value)
        }
        tableView.reloadData()
    }
}
