//
//  Tab.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 16.05.2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    
    case info = "Info"
    case wallet = "Wallet"
    case others = "Others"
    
    var systemImage: String {
        switch self {
        case .info:
            return "house"
        case .wallet:
            return "wallet.pass"
        case .others:
            return "hand.raised"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
