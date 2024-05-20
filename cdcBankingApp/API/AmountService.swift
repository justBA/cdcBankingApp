//
//  AmountService.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation
import Combine

enum Currency {
    case usd
    case khr
}

protocol AmountServiceProtocol {
    func getSaving(isFirstLoad: Bool, currency: Currency) -> AnyPublisher<[AccountInfo], Error>
    func getUsdFixed(isFirstLoad: Bool, currency: Currency) -> AnyPublisher<[AccountInfo], Error>
    func getUsdDigital(isFirstLoad: Bool, currency: Currency) -> AnyPublisher<[AccountInfo], Error>
}

enum AmountServiceEndpoint: Endpoint {
    case getUsdSaving1
    case getUsdSaving2
    case getUsdFixed1
    case getUsdFixed2
    case getUsdDigital1
    case getUsdDigital2
    case getKHRSaving1
    case getKHRSaving2
    case getKHRFixed1
    case getKHRFixed2
    case getKHRDigital1
    case getKHRDigital2
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getUsdSaving1:
            return "usdSavings1.json"
        case .getUsdSaving2:
            return "usdSavings2.json"
        case .getUsdFixed1:
            return "usdFixed1.json"
        case .getUsdFixed2:
            return "usdFixed2.json"
        case .getUsdDigital1:
            return "usdDigital1.json"
        case .getUsdDigital2:
            return "usdDigital2.json"
        case .getKHRSaving1:
            return "khrSavings1.json"
        case .getKHRSaving2:
            return "khrSavings2.json"
        case .getKHRFixed1:
            return "khrFixed1.json"
        case .getKHRFixed2:
            return "khrFixed2.json"
        case .getKHRDigital1:
            return "khrDigital1.json"
        case .getKHRDigital2:
            return "khrDigital2.json"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}


final class AmountService: AmountServiceProtocol {
    func getSaving(isFirstLoad: Bool, currency: Currency) -> AnyPublisher<[AccountInfo], any Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        // promise type is Result<[Player], Error>
        return Future<[AccountInfo], Error> { [weak self] promise in
            let endpoint: AmountServiceEndpoint
            if isFirstLoad {
                if currency == .usd {
                    endpoint = .getUsdSaving1
                } else {
                    endpoint = .getKHRSaving1
                }
            } else {
                if currency == .usd {
                    endpoint = .getUsdSaving2
                } else {
                    endpoint = .getKHRSaving2
                }
            }
            guard let urlRequest = self?.getUrlRequest(endpoint: endpoint) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<AccountList>.self, from: data)
                    if baseResponse.msgContent?.uppercased() == "SUCCESS" {
                        promise(.success(baseResponse.result?.savingsList ?? []))
                    } else {
                        promise(.failure(ServiceError.other(baseResponse.msgCode ?? "")))
                    }
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getUsdFixed(isFirstLoad: Bool, currency: Currency) -> AnyPublisher<[AccountInfo], any Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        // promise type is Result<[Player], Error>
        return Future<[AccountInfo], Error> { [weak self] promise in
            let endpoint: AmountServiceEndpoint
            if isFirstLoad {
                if currency == .usd {
                    endpoint = .getUsdFixed1
                } else {
                    endpoint = .getKHRFixed1
                }
            } else {
                if currency == .usd {
                    endpoint = .getUsdFixed2
                } else {
                    endpoint = .getKHRFixed2
                }
            }
            guard let urlRequest = self?.getUrlRequest(endpoint: endpoint) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<AccountList>.self, from: data)
                    if baseResponse.msgContent?.uppercased() == "SUCCESS" {
                        promise(.success(baseResponse.result?.fixedDepositList ?? []))
                    } else {
                        promise(.failure(ServiceError.other(baseResponse.msgCode ?? "")))
                    }
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getUsdDigital(isFirstLoad: Bool, currency: Currency) -> AnyPublisher<[AccountInfo], any Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        // promise type is Result<[Player], Error>
        return Future<[AccountInfo], Error> { [weak self] promise in
            let endpoint: AmountServiceEndpoint
            if isFirstLoad {
                if currency == .usd {
                    endpoint = .getUsdDigital1
                } else {
                    endpoint = .getKHRDigital1
                }
            } else {
                if currency == .usd {
                    endpoint = .getUsdDigital2
                } else {
                    endpoint = .getKHRDigital2
                }
            }
            guard let urlRequest = self?.getUrlRequest(endpoint: endpoint) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let baseResponse = try JSONDecoder().decode(BaseResponse<AccountList>.self, from: data)
                    if baseResponse.msgContent?.uppercased() == "SUCCESS" {
                        promise(.success(baseResponse.result?.digitalList ?? []))
                    } else {
                        promise(.failure(ServiceError.other(baseResponse.msgCode ?? "")))
                    }
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getUrlRequest(endpoint: AmountServiceEndpoint) -> URLRequest? {
        do {
            return try endpoint.asURLRequest()
        } catch {
            return nil
        }
    }
}

