//
//  Banner.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import Foundation

// MARK: - Result
struct BannerResult: Codable {
    var bannerList: [Banner]?
}

// MARK: - BannerList
struct Banner: Codable {
    var adSeqNo: Int?
    var linkURL: String?

    enum CodingKeys: String, CodingKey {
        case adSeqNo
        case linkURL = "linkUrl"
    }
}
