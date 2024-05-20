//
//  HomeViewController.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import UIKit
import Combine
class HomeViewController: UIViewController {
    let limitHeight = 60.0
    var needRefresh = false
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var accountBalanceView: AccountBalanceView!
    @IBOutlet weak var favoriteView: FavoriteView!
    @IBOutlet weak var refreshView: UIView!
    @IBOutlet weak var slideBannerView: SlideBannerView!
    @IBOutlet weak var scrollView: UIScrollView!
    var viewModel: HomeViewModel!
    private var bindings = Set<AnyCancellable>()
    private var skeletonViews: [SkeletonView] = []
    
    @IBAction func tapNotification(_ sender: Any) {
        self.router(.notification)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        refreshView.isHidden = true
        refreshView.addSubview(activityIndicationView)
        activityIndicationView.centerSuperview()
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        viewModel.getNotification(isFirstLoad: true)
        viewModel.getKHRAmount(isFirstLoad: true)
        viewModel.getUSDAmount(isFirstLoad: true)
        viewModel.getFavorite(isFirstLoad: true)
        viewModel.getBannerList()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slideBannerView.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if slideBannerView != nil {
            slideBannerView.stopTimer()
        }
    }
    
    deinit {
        if slideBannerView != nil {
            slideBannerView.stopTimer()
        }
    }
    
    private func setUpBindings() {
        func bindViewToViewModel() {
        }
        
        func bindViewModelToView() {
            viewModel.$notificationData
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] data in
                    if data.contains(where: { $0.status == false}) {
                        self?.notificationButton.setImage(AppImage.iconBell02Active, for: .normal)
                    } else {
                        self?.notificationButton.setImage(AppImage.iconBell01Nomal, for: .normal)
                    }
                    
                })
                .store(in: &bindings)
            
            let stateValueHandler: (HomeViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.startLoading()
                case .finishedLoading:
                    self?.stopLoading()
                case .error(let error):
                    self?.stopLoading()
                    self?.showError(error)
                }
            }
            
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
            
            Publishers.CombineLatest3(viewModel.$usdAmount, viewModel.$khrAmount, accountBalanceView.showHideAmountSubject)
                .receive(on: RunLoop.main)
                .sink { [weak self] (usdAmount, khrAmount, isShow) in
                    self?.accountBalanceView.configureView(usdAmount: usdAmount, khrAmount: khrAmount, isShowValue: isShow)
                }
                .store(in: &bindings)
                
            viewModel.$favoriteListData
                .receive(on: RunLoop.main)
                .sink{ [weak self] listData in
                    self?.favoriteView.isHidden = listData.count == 0
                    self?.favoriteView.favoriteListData = listData
                }
                .store(in: &bindings)
            viewModel.$bannerList
                .receive(on: RunLoop.main)
                .sink{ [weak self] listData in
                    self?.slideBannerView.banners = listData
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }

    func startLoading() {
//        accountBalanceView.showSkeletonView()
    }
    
    func stopLoading() {
        accountBalanceView.hideSkeletonViews()
        hideRefreshView()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.layoutIfNeeded()

        if scrollView.contentOffset.y < 0
            && scrollView.contentOffset.y > -limitHeight {
            showRefreshView()
        }
        
        if scrollView.contentOffset.y < -limitHeight {
            needRefresh = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if needRefresh {
            needRefresh = false
            viewModel.retry()
            activityIndicationView.startAnimating()
        } else {
            hideRefreshView()
        }
    }
    
    func showRefreshView() {
        refreshView.isHidden = false
        activityIndicationView.startAnimating()
        accountBalanceView.showSkeletonView()
    }
    
    func hideRefreshView() {
        refreshView.isHidden = true
        activityIndicationView.stopAnimating()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if needRefresh {
            needRefresh = false
            viewModel.retry()
        } else {
            hideRefreshView()
        }
    }
}
