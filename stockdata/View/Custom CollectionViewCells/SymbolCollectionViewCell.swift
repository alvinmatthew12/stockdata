//
//  SymbolCollectionViewCell.swift
//  stockdata
//
//  Created by Alvin Matthew Pratama on 25/12/20.
//

import UIKit

class SymbolCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var closeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 8
        symbolLabel.text = "--"
        closeImage.isHidden = true
    }

}
