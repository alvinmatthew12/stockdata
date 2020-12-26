//
//  PickerViewTableViewCell.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import UIKit

protocol PickerViewTableViewCellDelegate {
    func didSelectItem(key: String, value: String)
}

class PickerViewTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var delegate: PickerViewTableViewCellDelegate?
    
    var key: String = ""
    var items: [String] = []
    var selectedItem: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DispatchQueue.main.async { [self] in
            if let index = items.firstIndex(of: selectedItem) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectItem(key: key, value: items[row])
    }
    
}
