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
}
