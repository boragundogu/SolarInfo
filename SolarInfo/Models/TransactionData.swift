//
//  TransactionData.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import Foundation


struct TransactionData: Codable {
    let meta: Meta
}


struct Meta: Codable{
    let totalCount: Int
}
