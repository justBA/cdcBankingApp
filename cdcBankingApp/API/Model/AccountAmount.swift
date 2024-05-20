//
//  AccountAmount.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation

// MARK: - Result
struct AccountList: Codable {
    var digitalList: [AccountInfo]?
    var fixedDepositList : [AccountInfo]?
    var savingsList: [AccountInfo]?
}

// MARK: - DigitalList
struct AccountInfo: Codable {
    var account, curr: String?
    var balance: Double?
}
