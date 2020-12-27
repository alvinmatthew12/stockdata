//
//  HomeViewController.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 27/12/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var firstCardView: UIView!
    @IBOutlet weak var secondCardView: UIView!
    @IBOutlet weak var thirdCardView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Stock Data"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstCardView.layer.cornerRadius = 8
        secondCardView.layer.cornerRadius = 8
        thirdCardView.layer.cornerRadius = 8
    }
}
