//
//  BaseResponse.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 19/5/24.
//

import Foundation

public struct BaseResponse<DataType: Codable>: Codable {
    public var msgCode, msgContent: String?
    public var result: DataType?
}

public struct BaseListResponse<DataType: Codable>: Codable {
    public var msgCode, msgContent: String?
    public var result: [DataType]?
}

