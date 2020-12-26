//
//  EditAPIKeyViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 26/12/20.
//

import UIKit

protocol EditAPIKeyViewControllerDelegate {
    func didUpdateAPIKey(newApiKey: String)
}

class EditAPIKeyViewController: UIViewController, ConfigurationModelDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var configurationModel = ConfigurationModel()
    var delegate: EditAPIKeyViewControllerDelegate?
    
    var newApiKey: String = ""
    
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
        textField.delegate = self
        
        errorMessageLabel.isHidden = true
        
        textField.addBorder(radius: 12, color: UIColor(named: K.Color.grey)!.cgColor)
        textField.addPadding(padding: .equalSpacing(20))
        
        configurationModel.delegate = self
        if let apiKey = configurationModel.getAPIKey() {
            textField.text = apiKey
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        checkAPIKey()
    }
    
    func checkAPIKey() {
        saveButton.isEnabled = false
        if textField.text == nil || textField.text == "" {
            saveButton?.isEnabled = true
            errorMessageLabel.text = "API Key can't be empty"
            errorMessageLabel.isHidden = false
            return
        }
        newApiKey = textField.text!
        configurationModel.checkAPIKey(newApiKey)
    }
    
    func didCheckAPIKey(isValid: Bool) {
        DispatchQueue.main.async { [self] in
            if isValid == true {
                configurationModel.updateAPIKey(newApiKey)
                delegate?.didUpdateAPIKey(newApiKey: newApiKey)
                navigationController?.popViewController(animated: true)
            } else {
                saveButton.isEnabled = true
                errorMessageLabel.text = "Invalid API Key"
                errorMessageLabel.isHidden = false
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension EditAPIKeyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            errorMessageLabel.isHidden = true
            return true
        } else {
            textField.placeholder = "Enter API keys..."
            errorMessageLabel.text = "API Key can't be empty"
            errorMessageLabel.isHidden = false
            return false
        }
    }
}
