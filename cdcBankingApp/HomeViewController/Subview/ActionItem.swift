//
//  ActionItem.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class ActionItem: BaseViewXib {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var topPaddingContraint: NSLayoutConstraint!
    override func setUpViews() {
        itemLabel.font = .systemFont(ofSize: 14, weight: .regular)
        itemLabel.textColor = .cubeColorSystemGray7
    }
    
    func updateData(title: String, image: UIImage, isFavorite: Bool) {
        itemLabel.text = title
        itemImageView.image = image
        topPaddingContraint.constant = isFavorite ? 0 : 8
    }
}
