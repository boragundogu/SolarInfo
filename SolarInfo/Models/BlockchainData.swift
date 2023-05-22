//
//  BlockchainData.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import Foundation


struct BlockchainData : Codable {
    let data:  DataClass
}

struct DataClass: Codable {
    let block: Block
    let burned: Burned
    let supply: String
}

struct Block: Codable {
    let height: Int
    let id: String
}

struct Burned: Codable {
    let total: String
}
