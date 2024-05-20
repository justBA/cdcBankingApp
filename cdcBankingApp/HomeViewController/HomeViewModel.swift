//
//  HomeViewModel.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation
import Combine

enum HomeViewModelError: Error, Equatable {
    case notificationFetch
    case amountFetch
}

enum HomeViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(HomeViewModelError)
}

class HomeViewModel {
    @Published private(set) var notificationData: [Message] = []
    @Published private(set) var state: HomeViewModelState = .loading
    @Published private(set) var usdAmount: Double = 0
    @Published private(set) var khrAmount: Double = 0
    @Published private(set) var favoriteListData: [FavoriteItem] = []
    @Published private(set) var bannerList: [Banner] = []
    private let notificationService: NotificationServiceProtocol
    private let amountService: AmountServiceProtocol
    private let favoriteService: FavoriteServiceProtocol
    private let bannerAPIService: BannerAPIServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(notificationService: NotificationServiceProtocol = NotificationService(), 
         amountService: AmountServiceProtocol = AmountService(),
         favoriteService: FavoriteServiceProtocol = FavoriteService(),
         bannerAPIService: BannerAPIServiceProtocol = BannerAPIService()) {
        self.notificationService = notificationService
        self.amountService = amountService
        self.favoriteService = favoriteService
        self.bannerAPIService = bannerAPIService
    }

    func retry() {
        getNotification(isFirstLoad: false)
        getUSDAmount(isFirstLoad: false)
        getKHRAmount(isFirstLoad: false)
        getFavorite(isFirstLoad: false)
        
    }
}

extension HomeViewModel {
    func getNotification(isFirstLoad: Bool) {
        state = .loading
        let getNotiCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.notificationFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let getNotiValueHandler: ([Message]) -> Void = { [weak self] messages in
            self?.notificationData = messages
        }
        
        notificationService
            .getNotification(isFirstLoad: isFirstLoad)
            .sink(receiveCompletion: getNotiCompletionHandler, 
                  receiveValue: getNotiValueHandler)
            .store(in: &bindings)
    }
    
    func getUSDAmount(isFirstLoad: Bool) {
        state = .loading
        let combinedPublisher = Publishers.CombineLatest3(
            amountService.getSaving(isFirstLoad: isFirstLoad, currency: .usd),
            amountService.getUsdFixed(isFirstLoad: isFirstLoad, currency: .usd),
            amountService.getUsdDigital(isFirstLoad: isFirstLoad, currency: .usd))
        combinedPublisher
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    self?.state = .error(.amountFetch)
                case .finished:
                    self?.state = .finishedLoading
                }
            } receiveValue: { [weak self] (savingAccounts, fixedAccount, digitalAccount) in
                let sumSaving = savingAccounts.filter({ $0.curr == "USD" }).compactMap({ $0.balance }).reduce(0, +)
                let sumFixed = fixedAccount.filter({ $0.curr == "USD" }).compactMap({ $0.balance }).reduce(0, +)
                let sumDigital = digitalAccount.filter({ $0.curr == "USD" }).compactMap({ $0.balance }).reduce(0, +)
                self?.usdAmount = sumSaving + sumFixed + sumDigital
            }
            .store(in: &bindings)
    }
    
    func getKHRAmount(isFirstLoad: Bool) {
        state = .loading
        let combinedPublisher = Publishers.CombineLatest3(
            amountService.getSaving(isFirstLoad: isFirstLoad, currency: .khr),
            amountService.getUsdFixed(isFirstLoad: isFirstLoad, currency: .khr),
            amountService.getUsdDigital(isFirstLoad: isFirstLoad, currency: .khr))
        combinedPublisher
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    self?.state = .error(.amountFetch)
                case .finished:
                    self?.state = .finishedLoading
                }
            } receiveValue: { [weak self] (savingAccounts, fixedAccount, digitalAccount) in
                let sumSaving = savingAccounts.filter({ $0.curr == "KHR" }).compactMap({ $0.balance }).reduce(0, +)
                let sumFixed = fixedAccount.filter({ $0.curr == "KHR" }).compactMap({ $0.balance }).reduce(0, +)
                let sumDigital = digitalAccount.filter({ $0.curr == "KHR" }).compactMap({ $0.balance }).reduce(0, +)
                self?.khrAmount = sumSaving + sumFixed + sumDigital
            }
            .store(in: &bindings)
    }
    
    func getFavorite(isFirstLoad: Bool) {
        state = .loading
        let getNotiCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.notificationFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let getNotiValueHandler: ([FavoriteItem]) -> Void = { [weak self] data in
            self?.favoriteListData = data
        }
        
        favoriteService
            .getFavoriteList(isFirstLoad: isFirstLoad)
            .sink(receiveCompletion: getNotiCompletionHandler,
                  receiveValue: getNotiValueHandler)
            .store(in: &bindings)
    }
    
    func getBannerList() {
        state = .loading
        let getNotiCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.notificationFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let getNotiValueHandler: ([Banner]) -> Void = { [weak self] data in
            self?.bannerList = data
        }
        
        bannerAPIService
            .getBannerList()
            .sink(receiveCompletion: getNotiCompletionHandler,
                  receiveValue: getNotiValueHandler)
            .store(in: &bindings)
    }
}
