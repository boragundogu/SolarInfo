//
//  Card.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 18.07.2023.
//

import Foundation


struct Card: Identifiable {
    var id: String = UUID().uuidString
    var cardImage: String
    var rotation: CGFloat = 0
}
