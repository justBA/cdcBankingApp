//
//  ListActionView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class ListActionView: BaseViewXib {
    let titles = ["Transfer", "Payment", "Utility", "QR Pay Scan", "My QR Code", "Top up"]
    let images = [AppImage.button00ElementMenuTransfer,
                 AppImage.button00ElementMenuPayment,
                 AppImage.button00ElementMenuUtility,
                 AppImage.button01Scan,
                 AppImage.button00ElementMenuQRcode,
                 AppImage.button00ElementMenuTopUp]
    @IBOutlet var listActionView: [ActionItem]!
    
    override func setUpViews() {
        for (index, actionView) in listActionView.enumerated() {
            actionView.itemLabel.text = titles[index]
            actionView.itemImageView.image = images[index]
        }
    }
}
