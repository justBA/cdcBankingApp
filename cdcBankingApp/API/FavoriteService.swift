//
//  FavoriteService.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import Foundation
import Combine

protocol FavoriteServiceProtocol {
    func getFavoriteList(isFirstLoad: Bool) -> AnyPublisher<[FavoriteItem], Error>
}

enum FavoriteEndpoint: Endpoint {
    case getFavorite
    case getFavoriteEmpty
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getFavorite:
            return "favoriteList.json"
        case .getFavoriteEmpty:
            return "emptyFavoriteList.json"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}


final class FavoriteService: FavoriteServiceProtocol {
    func getFavoriteList(isFirstLoad: Bool) -> AnyPublisher<[FavoriteItem], any Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        // promise type is Result<[Player], Error>
        return Future<[FavoriteItem], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(endpoint: isFirstLoad ? .getFavoriteEmpty : .getFavorite) else {
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
                    let baseResponse = try JSONDecoder().decode(BaseResponse<FavoriteResult>.self, from: data)
                    if baseResponse.msgContent?.uppercased() == "SUCCESS" {
                        promise(.success(baseResponse.result?.favoriteList ?? []))
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
    
    private func getUrlRequest(endpoint: FavoriteEndpoint) -> URLRequest? {
        do {
            return try endpoint.asURLRequest()
        } catch {
            return nil
        }
    }
}

