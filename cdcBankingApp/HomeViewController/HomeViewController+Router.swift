//
//  HomeViewController+Router.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation

enum HomeRoute {
    case notification
}

extension HomeViewController {
    func router(_ route: HomeRoute) {
        DispatchQueue.main.async {
            switch route {
            case .notification:
                self.openNofitication()
            }
        }
    }
    
    private func openNofitication() {
        let notiVC = NotificationViewController.instantiateFromNib()
        notiVC.viewModel = NotificationViewModel(notificationData: self.viewModel.notificationData)
        self.pushVC(notiVC, animated: true)
    }
}
