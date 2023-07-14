//
//  OutgoingData.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 14.07.2023.
//

import Foundation

 struct OutgoingData: Codable {
    let data: [OutData]
 }
 
 struct OutData: Codable {
    let asset: OutAsset
    let sender: String
 }
 
 struct OutAsset: Codable {
    let transfers: [OutTransfer]
   // let votes: Votes
 }

// struct Votes: Codable {
//    let emsy: Double
//}
 
 struct OutTransfer: Codable {
    let amount: String
    let recipientId: String
 }

