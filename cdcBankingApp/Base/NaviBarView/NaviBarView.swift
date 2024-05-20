//
//  NaviBarView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit

open class NaviBarView: BaseViewXib {
    
    @IBOutlet private weak var titleLabel       : UILabel!
    @IBOutlet private weak var leftImageView    : UIImageView!
    @IBOutlet private weak var leftButton       : UIButton!
    var leftTapped: (() -> Void)?
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        self.leftTapped?()
    }
    open override func setUpViews() {
        titleLabel.textColor = .cubeColorSystemGray10
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        leftImageView.image = AppImage.iconArrowWTailBack
        self.backgroundColor = .white250
    }
    
    func configView(_ title: String? = nil,
                    titleFont: UIFont? = nil,
                    isBack: Bool = true,
                    hideAction: Bool = false,
                    leftTapped: (() -> Void)? = nil) {
        titleLabel.text = title
        if let titleFont = titleFont {
            titleLabel.font = titleFont
        }
        leftButton.isHidden = hideAction
        leftImageView.isHidden = hideAction
        self.leftTapped = leftTapped
    }
    
    func configView(_ title: String? = nil) {
        titleLabel.text = title
        leftImageView.isHidden = true
    }

}
