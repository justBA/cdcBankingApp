//
//  Constant.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit

class AppImage {
    static let iconBell01Nomal = UIImage(named: "iconBell01Nomal")!
    static let iconBell02Active = UIImage(named: "iconBell02Active")!
    static let iconArrowWTailBack = UIImage(named: "iconArrowWTailBack")!
    static let iconEye01On = UIImage(named: "iconEye01On")!
    static let iconEye01Off = UIImage(systemName: "eye.slash")!.withRenderingMode(.alwaysTemplate)
    static let button00ElementMenuTransfer = UIImage(named: "button00ElementMenuTransfer")!
    static let button00ElementMenuPayment = UIImage(named: "button00ElementMenuPayment")!
    static let button00ElementMenuUtility = UIImage(named: "button00ElementMenuUtility")!
    static let button01Scan = UIImage(named: "button01Scan")!
    static let button00ElementMenuQRcode = UIImage(named: "button00ElementMenuQRcode")!
    static let button00ElementMenuTopUp = UIImage(named: "button00ElementMenuTopUp")!
    static let button00ElementScrollBuilding = UIImage(named: "button00ElementScrollBuilding")!
    static let button00ElementScrollCreditCard = UIImage(named: "button00ElementScrollCreditCard")!
    static let button00ElementScrollMobile = UIImage(named: "button00ElementScrollMobile")!
    static let button00ElementScrollTree = UIImage(named: "button00ElementScrollTree")!
}

class Configuration {
    static var baseURL: URL {
        return URL(string: "https://willywu0201.github.io/data/")!
    }
}
