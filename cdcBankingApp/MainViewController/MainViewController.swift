//
//  MainViewController.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation
import UIKit

enum TabbarType: String, CaseIterable {
    case home
    case account
    case location
    case service
    
    var defaultImage: UIImage {
        switch self {
        case .home:
            return UIImage(named: "icTabbarHomeDefault")?.withRenderingMode(.alwaysOriginal) ?? .actions
        case .account:
            return UIImage(named: "icTabbarAccountDefault")?.withRenderingMode(.alwaysOriginal) ?? .actions
        case .location:
            return UIImage(named: "icTabbarLocationDefault")?.withRenderingMode(.alwaysOriginal) ?? .actions
        case .service:
            return UIImage(named: "icTabbarServiceDefault")?.withRenderingMode(.alwaysOriginal) ?? .actions
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return UIImage(named:"icTabbarHomeActive")?.withRenderingMode(.alwaysOriginal) ?? .actions
        case .account:
            return UIImage(named: "icTabbarAccountActive")?.withRenderingMode(.alwaysOriginal) ?? .actions
        case .location:
            return UIImage(named: "icTabbarLocationActive")?.withRenderingMode(.alwaysOriginal) ?? .actions
        case .service:
            return UIImage(named: "icTabbarServiceActive")?.withRenderingMode(.alwaysOriginal) ?? .actions
        }
    }
    
    var name: String {
        switch self {
        case.home:
            return "Home"
        case .account:
            return "Account"
        case .location:
            return "Location"
        case .service:
            return "Service"
        }
    }
}

class MainViewController: UIViewController {
    
    private let customTabBarView = UIView()
    private var viewControllers: [UIViewController] = []
    private var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setTabbar()
    }
    
    private func setTabbar() {
        let buttonTitles = [TabbarType.home.name,
                            TabbarType.account.name,
                            TabbarType.location.name,
                            TabbarType.service.name]
        let buttonImages = [TabbarType.home.defaultImage,
                            TabbarType.account.defaultImage,
                            TabbarType.location.defaultImage,
                            TabbarType.service.defaultImage]
        let buttonSelectedImage = [TabbarType.home.selectedImage,
                                   TabbarType.account.selectedImage,
                                   TabbarType.location.selectedImage,
                                   TabbarType.service.selectedImage]
        let buttonWidth = (view.frame.width - 50) / CGFloat(buttonTitles.count)
        
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton()
            button.centerButtonImageAndTitle()
            button.setFont(.systemFont(ofSize: 12, weight: .semibold))
            button.setTitleColor(.cubeColorSystemGray7, for: .normal)
            button.setTitleColor(.orange01, for: .selected)
            button.setTitle(title, for: .normal)
            button.setImage(buttonImages[index], for: .normal)
            button.setImage(buttonSelectedImage[index], for: .selected)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.frame = CGRect(x: buttonWidth * CGFloat(index), y: 0, width: buttonWidth, height: 48)
            customTabBarView.addSubview(button)
        }
        
        let homeVC = HomeViewController.instantiateFromNib()

        homeVC.viewModel = HomeViewModel()
        
        let accountVC = AccountViewController.instantiateFromNib()
        
        let locationVC = LocationViewController.instantiateFromNib()
        
        let serviceVC = ServiceViewController.instantiateFromNib()
        
        viewControllers = [homeVC, accountVC, locationVC, serviceVC]
        
        if let firstViewController = viewControllers.first {
            displayContentController(firstViewController)
            for customButton in customTabBarView.subviews where customButton is UIButton {
                if customButton.tag == 0 {
                    (customButton as! UIButton).isSelected = true
                } else {
                    (customButton as! UIButton).isSelected = false
                }
            }
        }
    }
    
    private func setUpViews() {
        customTabBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        customTabBarView.clipsToBounds = true
        customTabBarView.layer.masksToBounds = false
        customTabBarView.layer.cornerRadius = 25
        customTabBarView.layer.shadowRadius = 2
        customTabBarView.layer.shadowColor = UIColor.black.cgColor
        customTabBarView.layer.shadowOpacity = 0.3
        customTabBarView.backgroundColor = .white
        customTabBarView.tintColor = .orange01
        view.addSubview(customTabBarView)
        customTabBarView.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                leadingConstant: 24,
                                bottomConstant: 22,
                                trailingConstant: 24,
                                heightConstant: 50)
        
    }
    
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        let newFrame = CGRect(x: 0, y: 0,
    //                              width: view.frame.width,
    //                              height: view.frame.height)
    //        viewControllers.forEach { viewController in
    //            viewController.view.frame = newFrame
    //        }
    //    }
    
    private func displayContentController(_ content: UIViewController) {
        addChild(content)
        content.view.frame = view.bounds
        view.insertSubview(content.view, belowSubview: customTabBarView)
        content.didMove(toParent: self)
        currentViewController = content
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedViewController = viewControllers[index]
        for customButton in customTabBarView.subviews where customButton is UIButton {
            if customButton.tag == sender.tag {
                (customButton as! UIButton).isSelected = true
            } else {
                (customButton as! UIButton).isSelected = false
            }
        }
    }
}
