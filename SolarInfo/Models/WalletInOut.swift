//
//  WalletInOut.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 17.05.2023.
//

import Foundation

struct WalletInOut: Decodable {
    let data: [DataValue]
 }
 
 struct DataValue: Decodable {
    let asset: Asset
 }
 
 struct Asset: Decodable {
    let transfers: [Transfer]
 }
 
 struct Transfer: Decodable {
    let amount: String
    let recipientId: String
 }



