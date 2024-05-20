//
//  NotificationViewController+Router.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation

enum NotificationRoute {
    case back
}

extension NotificationViewController {
    func router(_ route: NotificationRoute) {
        DispatchQueue.main.async {
            switch route {
            case .back:
                self.popVC(animated: true)
            }
        }
    }
}
