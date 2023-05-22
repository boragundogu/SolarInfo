//
//  StatsView.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import SwiftUI

struct StatsView: View {
    
    var initialSupply = 520737576
    @State private var timer = Timer()
    
    @State var txLabel: String
    @State var supplyLabel: String
    @State var heightLabel: String
    @State var burnedLabel: String
    @State var createdLabel: String
    @State var priceLabel: String
    
    
    var body: some View {
        
        ZStack {
            Color("bg").ignoresSafeArea()
            VStack{
                Text("Total Transaction:" + " " + "\(txLabel)")
                    .foregroundColor(.white)
                Text("Total Supply:" + " " + "\(supplyLabel)")
                    .foregroundColor(.white)
                Text("Total Block Height:" + " " + "\(heightLabel)")
                    .foregroundColor(.white)
                Text("Total Burned:" + " " + "\(burnedLabel)")
                    .foregroundColor(.white)
                Text("Created:" + " " + "\(createdLabel)")
                    .foregroundColor(.white)
                Text("Price:" + " " + "\(priceLabel)")
                    .foregroundColor(.white)
            }
            .onAppear {
                fetchMainData()
                callFunc()
                
        }
        }

    }
    
    func callFunc(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            return fetchMarketData()
        }
    }
    
    func fetchMarketData(){
        
        guard let marketUrl = URL(string: "https://api.coingecko.com/api/v3/coins/swipe") else {
            return
        }
        
        URLSession.shared.dataTask(with: marketUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching market data \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            do {
                let marketInfo = try JSONDecoder().decode(MarketData.self, from: data)
                let price = marketInfo.market_data.current_price
                let currentPrice = String(price["usd"]!).prefix(4)
                
                priceLabel.self = String(currentPrice)
                //return self.fetchMarketData()
            }
            catch {
                print("error decoding market data \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    func fetchMainData(){
        
        guard let txUrl = URL(string: "https://api.solar.org/api/transactions") else {
            return
        }
        
        guard let statsUrl = URL(string: "https://api.solar.org/api/blockchain") else {
            return
        }
        
        URLSession.shared.dataTask(with: statsUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching stats data \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            do {
                let statsInfo = try JSONDecoder().decode(BlockchainData.self, from: data)
                let supply = Int(statsInfo.data.supply.prefix(9))!
                let height = statsInfo.data.block.height
                let burned = Int(statsInfo.data.burned.total.prefix(5))!
                let created = supply - initialSupply.self
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let supplyString = formatter.string(for: supply)
                let heightString = formatter.string(for: height)
                let burnedString = formatter.string(for: burned)
                let createdString = formatter.string(for: created)
                supplyLabel.self = supplyString!
                heightLabel.self = heightString!
                burnedLabel.self = burnedString!
                createdLabel.self = createdString!
                
                return self.fetchMainData()
                
            }
            catch {
                print("error decoding stats data \(error.localizedDescription)")
            }
        }.resume()
        
        URLSession.shared.dataTask(with: txUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching tx data \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            do {
                let txInfo = try JSONDecoder().decode(TransactionData.self, from: data)
                let totalT = Int(txInfo.meta.totalCount)
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let txString = formatter.string(for: totalT)
                txLabel.self = txString!
            }
            catch {
                print("error decoding tx data \(error.localizedDescription)")
            }
        }.resume()    
        
    }
}






struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(txLabel: "", supplyLabel: "", heightLabel: "", burnedLabel: "", createdLabel: "", priceLabel: "")
    }
}
