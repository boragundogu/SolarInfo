//
//  Delegate.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.06.2023.
//

import Foundation



struct Delegate: Codable {
    let data: [DelegateData]
}

struct DelegateData: Codable {
    var username: String
    
}
