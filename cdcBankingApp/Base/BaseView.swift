//
//  BaseView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

open class BaseView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }

    open func setUpViews() {

    }
}
