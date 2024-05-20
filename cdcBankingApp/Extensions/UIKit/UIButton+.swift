//
//  UIButton+.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//


import UIKit

extension UIButton {
    func centerButtonImageAndTitle() {
        var config = UIButton.Configuration.plain()
        config.titlePadding = 4
        config.imagePlacement = .top
        config.imagePadding = 4
        config.background.backgroundColor = .clear
        self.configuration = config
    }
    
    func setFont(_ font: UIFont) {
        self.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }
    }
}
