//
//  BannerAPIService.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import Foundation
import Combine

protocol BannerAPIServiceProtocol {
    func getBannerList() -> AnyPublisher<[Banner], Error>
}

enum BannerEndpoint: Endpoint {
    case getBanner
    
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "banner.json"
    }
    
    var headers: [String : String]? {
        return nil
    }
}


final class BannerAPIService: BannerAPIServiceProtocol {
    func getBannerList() -> AnyPublisher<[Banner], any Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<[Player], Error>
        return Future<[Banner], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(endpoint: .getBanner) else {
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
                    let baseResponse = try JSONDecoder().decode(BaseResponse<BannerResult>.self, from: data)
                    if baseResponse.msgContent?.uppercased() == "SUCCESS" {
                        promise(.success(baseResponse.result?.bannerList ?? []))
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
    
    private func getUrlRequest(endpoint: BannerEndpoint) -> URLRequest? {
        do {
            return try endpoint.asURLRequest()
        } catch {
            return nil
        }
    }
}


