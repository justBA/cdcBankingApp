//
//  PageControlView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class PageControlView: BaseView {
    
    lazy var stackView = UIStackView().build {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 8
        $0.axis = .horizontal
        $0.anchor(heightConstant: 6)
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateDot()
        }
    }
    
    var totalPage: Int = 3 {
        didSet {
            updateDot()
        }
    }
    
    override func setUpViews() {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    func updateDot() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<totalPage {
            let dotView = UIView()
            dotView.translatesAutoresizingMaskIntoConstraints = false
            dotView.layer.cornerRadius = 3
            NSLayoutConstraint.activate([
                dotView.heightAnchor.constraint(equalToConstant: 6),
                dotView.widthAnchor.constraint(equalToConstant: 6)
            ])
            if index == currentPage {
                dotView.backgroundColor = .black
            } else {
                dotView.backgroundColor = .cubeColorSystemGray5
            }
            stackView.addArrangedSubview(dotView)
        }
    }
}
