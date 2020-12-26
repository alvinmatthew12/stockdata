//
//  EditAPIKeyViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import UIKit

class EditAPIKeyViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        title = "API Key"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
        textField.selectAll(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAnywhere()
        
        errorMessageLabel.isHidden = true
        generateButton.isHidden = true
        
        textField.addBorder(radius: 12, color: UIColor(named: K.Color.grey)!.cgColor)
        textField.addPadding(padding: .equalSpacing(20))
        
        textField.text = "SINALNWR6553GGBL"
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        let isAPIKeyValid = checkAPIKey()
        if isAPIKeyValid {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func generateAPIKeyPressed(_ sender: UIButton) {
    }
    
    func checkAPIKey() -> Bool {
        let saveButton = navigationItem.rightBarButtonItem
        saveButton?.isEnabled = false
        if textField.text == nil || textField.text == "" {
            saveButton?.isEnabled = true
            errorMessageLabel.text = "API Key can't be empty"
            errorMessageLabel.isHidden = false
            return false
        }
        // code here to check API Key
        if textField.text == "SINALNWR6553GGBL" {
            saveButton?.isEnabled = true
            return true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            saveButton?.isEnabled = true
            errorMessageLabel.text = "Invalid API Key"
            errorMessageLabel.isHidden = false
        }
        return false
    }
}
