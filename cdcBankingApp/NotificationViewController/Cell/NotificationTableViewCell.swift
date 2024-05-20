//
//  NotificationTableViewCell.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var readStatusView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .cubeColorSystemGray10
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor =
            .cubeColorSystemGray10
        contentLabel.font = .systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = .battleshipGrey
        readStatusView.layer.masksToBounds = true
        readStatusView.layer.cornerRadius = 6
        readStatusView.backgroundColor = .orange01
        backgroundView?.backgroundColor = .white250
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(message: Message) {
        titleLabel.text = message.title
        timeLabel.text = message.updateDateTime
        contentLabel.text = message.message
        readStatusView.isHidden = message.status ?? true
    }
}
