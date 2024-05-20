//
//  NotificationViewModel.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation

class NotificationViewModel {
    private(set) var notificationData: [Message] = []
    
    init(notificationData: [Message]) {
        self.notificationData = notificationData
    }
}
