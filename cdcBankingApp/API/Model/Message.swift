//
//  Message.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation


struct MessageList: Codable {
    var messages: [Message]?
}

struct Message: Codable {
    var status: Bool?
    var updateDateTime: String?
    var title: String?
    var message: String?
}
