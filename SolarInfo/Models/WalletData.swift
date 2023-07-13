//
//  WalletData.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import Foundation


struct WalletData: Codable {
    let data: Wallet
}


struct Wallet: Codable {
    let address, publicKey, balance: String
//    let attributes: Attributes
}

//struct Attributes: Codable {
//    let delegate: Delegates
//}
//
//struct Delegates: Codable {
//    let username: String
//    let rank: Int
//}
