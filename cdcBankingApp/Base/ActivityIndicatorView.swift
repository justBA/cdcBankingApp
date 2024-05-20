//
//  ActivityIndicatorView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit

final class ActivityIndicatorView: UIActivityIndicatorView {
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        color = .white
        backgroundColor = .darkGray
        layer.cornerRadius = 5.0
        hidesWhenStopped = true
    }
}
