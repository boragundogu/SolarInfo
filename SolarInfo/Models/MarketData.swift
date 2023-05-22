//
//  MarketData.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import Foundation


struct MarketData: Codable {
    
    let market_data:market_data
    let symbol: String
}

struct market_data: Codable {
    let current_price: [String:Double]
}
