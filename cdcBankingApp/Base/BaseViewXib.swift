//
//  BaseViewXib.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit

open class BaseViewXib: UIView {
    var view : UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    func loadViewFromNib() {
        let nibName = String(describing: type(of: self))
        if let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
        setUpViews()
    }

    open func setUpViews() {

    }
}

