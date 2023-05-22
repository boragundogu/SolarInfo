//
//  BPModel.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import Foundation


struct BPModel: Decodable {
    let main: BPMain
    let data: BPData
}

struct BPMain: Decodable {
    let totalCount: Int
}

struct BPData: Decodable {
    let username, address : String
    let rank: Int
    let blokcs: Blocks
    let forged: Forged
}

struct Blocks: Decodable {
    let produced, missed: Int
    let productivity: Double
}

struct Forged: Decodable {
    let total: String
}
