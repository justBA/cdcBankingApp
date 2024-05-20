//
//  AccountBalanceView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation
import UIKit
import Combine

class AccountBalanceView: BaseViewXib {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showAmount: UIButton!
    @IBOutlet weak var usdTitleLabel: UILabel!
    @IBOutlet weak var usdAmountLabel: UILabel!
    @IBOutlet weak var khrTitleLabel: UILabel!
    @IBOutlet weak var khrAmountLabel: UILabel!
    @IBOutlet var skeletonViews: [SkeletonView]!
    let showHideAmountSubject = CurrentValueSubject<Bool, Never>(false)
    private var bindings = Set<AnyCancellable>()
    @IBAction func showHideAmountTapped(_ sender: UIButton) {
        var value = showHideAmountSubject.value
        value.toggle()
        showHideAmountSubject.send(value)
    }
    
    open override func setUpViews() {
        bind()
        titleLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        titleLabel.textColor = .cubeColorSystemGray5
        usdTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        usdTitleLabel.textColor = .cubeColorSystemGray7
        usdAmountLabel.font = .systemFont(ofSize: 32, weight: .medium)
        usdAmountLabel.textColor = .cubeColorSystemGray8
        khrTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        khrTitleLabel.textColor = .cubeColorSystemGray7
        khrAmountLabel.font = .systemFont(ofSize: 32, weight: .medium)
        khrAmountLabel.textColor = .cubeColorSystemGray8
    }
    
    func configureView(usdAmount: Double, khrAmount: Double, isShowValue: Bool) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        usdAmountLabel.text = isShowValue ? formatter.string(from: NSNumber(value: usdAmount)) : "********"
        khrAmountLabel.text = isShowValue ? formatter.string(from: NSNumber(value: khrAmount)) : "********"
    }
    
    func showSkeletonView() {
        DispatchQueue.main.async {
            self.skeletonViews.forEach {
                $0.isHidden = false
                $0.startShimmering()
            }
        }
    }
    
    func hideSkeletonViews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.skeletonViews.forEach {
                $0.stopShimmering()
                $0.isHidden = true
            }
        }
    }
    
    func bind() {
        showHideAmountSubject
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] isShow in
                if !isShow {
                    self?.showAmount.setImage(AppImage.iconEye01On, for: .normal)
                } else {
                    self?.showAmount.setImage(AppImage.iconEye01Off, for: .normal)
                    self?.showAmount.imageView?.tintColor = .orange01
                }
            }
            .store(in: &bindings)
    }
}
