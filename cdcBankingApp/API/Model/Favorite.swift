//
//  Favorite.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

enum TransType: String {
    case CUBC
    case Mobile
    case PMF
    case CreditCard
    
    func getImage() -> UIImage {
        switch self {
        case .CUBC:
            return AppImage.button00ElementScrollTree
        case .Mobile:
            return AppImage.button00ElementScrollMobile
        case .PMF:
            return AppImage.button00ElementScrollBuilding
        case .CreditCard:
            return AppImage.button00ElementScrollCreditCard
        }
    }
}
// MARK: - Result
struct FavoriteResult: Codable {
    var favoriteList: [FavoriteItem]?
}

// MARK: - FavoriteList
struct FavoriteItem: Codable {
    var nickname: String?
    var transType: TransType?
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case transType
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nickname = try? container.decode(String.self, forKey: .nickname)
        if let type = try? container.decode(String.self, forKey: .transType) {
            transType = TransType(rawValue: type)
        } else {
            transType = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(transType?.rawValue, forKey: .transType)
    }
}
