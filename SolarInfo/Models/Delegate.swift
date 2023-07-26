//
//  Delegate.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 26.07.2023.
//

import Foundation

struct Delegates: Codable{
    let data: [DelegateData]
}

struct DelegateData: Codable {
    
    let username, address: String
}
