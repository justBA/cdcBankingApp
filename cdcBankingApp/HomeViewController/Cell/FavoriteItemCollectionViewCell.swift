//
//  FavoriteItemCollectionViewCell.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class FavoriteItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var actionItemView: ActionItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(favoriteItem: FavoriteItem) {
        actionItemView.updateData(title: favoriteItem.nickname ?? "",
                                  image: favoriteItem.transType?.getImage() ?? UIImage(), 
                                  isFavorite: true)
    }
}
