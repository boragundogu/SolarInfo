//
//  TransactionData.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 18.07.2023.
//

import Foundation


struct TransactionData: Codable {
    
    let meta: Meta
}

struct Meta: Codable {
    let totalCount: Int
}
