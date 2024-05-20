//
//  NotificationService.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
    case other(String)
}

protocol NotificationServiceProtocol {
    func getNotification(isFirstLoad: Bool) -> AnyPublisher<[Message], Error>
}

enum NotificationEndpoint: Endpoint {
    case getNotification
    case getNotificationEmpty
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getNotification:
            return "notificationList.json"
        case .getNotificationEmpty:
            return "emptyNotificationList.json"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}


final class NotificationService: NotificationServiceProtocol {
    func getNotification(isFirstLoad: Bool) -> AnyPublisher<[Message], any Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }

        // promise type is Result<[Player], Error>
        return Future<[Message], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(endpoint: isFirstLoad ? .getNotificationEmpty : .getNotification) else {
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
                    let baseResponse = try JSONDecoder().decode(BaseResponse<MessageList>.self, from: data)
                    if baseResponse.msgContent?.uppercased() == "SUCCESS" {
                        promise(.success(baseResponse.result?.messages ?? []))
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
    
    private func getUrlRequest(endpoint: NotificationEndpoint) -> URLRequest? {
        do {
            return try endpoint.asURLRequest()
        } catch {
            return nil
        }
    }
}

