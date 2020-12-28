//
//  ViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAnywhere() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    struct ProgressDialog {
        static var alert = UIAlertController()
        static var progressView = UIProgressView()
        static var progressPoint : Float = 0{
            didSet{
                if(progressPoint == 1){
                    ProgressDialog.alert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadingStart(){
        ProgressDialog.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        ProgressDialog.alert.view.addSubview(loadingIndicator)
        present(ProgressDialog.alert, animated: true, completion: nil)
    }
    
    func loadingStop(){
        DispatchQueue.main.async {
            ProgressDialog.alert.dismiss(animated: true, completion: nil)
            self.view.endEditing(true)
        }
    }
}
