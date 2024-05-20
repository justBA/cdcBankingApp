//
//  NotificationViewController.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit

class NotificationViewController: BaseViewController {
    @IBOutlet weak var notiTableView: UITableView!
    
    var viewModel: NotificationViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setupTable()
        // Do any additional setup after loading the view.
    }

    override func setUpViews() {
        self.view.backgroundColor = .white250
        naviBarView.backgroundColor = .white250
        naviBarView.configView("Notification",
                               isBack: true,
                               hideAction: false,
                               leftTapped: { [weak self] in
            self?.router(.back)
        })
        
    }
    
    func setupTable() {
        notiTableView.dataSource = self
        notiTableView.delegate = self
        notiTableView.registerCellNib(NotificationTableViewCell.self)
        notiTableView.separatorStyle = .none
        notiTableView.contentInsetAdjustmentBehavior = .never
        notiTableView.backgroundColor = .clear
        notiTableView.sectionHeaderTopPadding = 0
        
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NotificationTableViewCell.self, indexPath: indexPath)
        cell.updateCell(message: viewModel.notificationData[indexPath.row])
        cell.backgroundColor = .white250
        return cell
    }
    
    
}
