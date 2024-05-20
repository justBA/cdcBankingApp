//
//  Endpoint.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable, Sendable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    public static let query = HTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public protocol Endpoint {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
}

public extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        var pathFormat = path
        if pathFormat.hasSuffix("/") {
            pathFormat.removeLast()
        }
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(pathFormat))
        urlRequest.httpMethod = method.rawValue
        
        let components = URLComponents(string: baseURL.appendingPathComponent(pathFormat).absoluteString)
        urlRequest.url = components?.url
        if let headers = headers {
            for header in headers {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
    
        urlRequest.timeoutInterval = 10.0
        return urlRequest
    }
    
}
