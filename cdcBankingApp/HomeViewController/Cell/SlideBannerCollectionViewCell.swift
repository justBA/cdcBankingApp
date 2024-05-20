//
//  SlideBannerCollectionViewCell.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class SlideBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
    }
    
    func setData(_ banner: Banner) {
        if let linkUrl = banner.linkURL {
            imageView.loadImageUsingCache(withUrl: linkUrl)
        }
    }
}
