//
//  StatsView.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import SwiftUI

struct Item: Identifiable {
    
    let id = UUID()
    let text: String
    let label: String
    let image: String
    let imgColor: Color
}

struct StatsView: View {


    var initialSupply = 520737576
    @State private var timer = Timer()
    

    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    @State var txLabel: String
    @State var supplyLabel: String
    @State var heightLabel: String
    @State var burnedLabel: String
    @State var createdLabel: String
    @State var priceLabel: String
    @State var percentLabel: String
    @State var capLabel: String
    
    
    
    var body: some View {
        
        let items = [
            Item(text: self.txLabel, label: "Transactions", image: "square.stack.3d.up", imgColor: Color("tx")),
            Item(text: self.supplyLabel, label: "Total Supply", image: "hockey.puck", imgColor: Color("supply")),
            Item(text: self.heightLabel, label: "Latest Block", image: "cube", imgColor: Color.yellow),
            Item(text: self.burnedLabel, label: "Total Burned", image: "flame", imgColor: Color.orange),
            Item(text: self.capLabel, label: "Market Cap", image: "chart.pie", imgColor: Color.mint),
            Item(text: self.priceLabel, label: "Price", image: "dollarsign.circle", imgColor: Color.green)
        ]
        
        NavigationView {
            ScrollView {
                Text("mrb")
                LazyVGrid(columns: adaptiveColumns, spacing: 15) {
                        ForEach(items) { item in
                                ZStack {
                                    Rectangle()
                                        .frame(width: 170, height: 170)
                                        .foregroundColor(Color("mainbg"))
                                        .cornerRadius(30)
                                    VStack(spacing: 10) {
                                        Image(systemName: "\(item.image)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .foregroundColor(item.imgColor)
                                        Text("\(item.label)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                        Text("\(item.text)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                    }
                                }
                        }
                    
                    if Double(percentLabel) ?? 0.0 < 0.0 {
                        HStack{
                            Image(systemName: "arrowtriangle.down.fill")
                                    .offset(x: 198, y: -45)
                                    .foregroundColor(.red)
                            Text("%" + " " + percentLabel)
                                .offset(x: 198, y: -45)
                                .foregroundColor(.red).opacity(0.7)
                            Text("|" + " " + "24H")
                                .offset(x: 195, y: -46)
                                .foregroundColor(.red).opacity(0.7)
                        }
                        .offset(x: 6)
                        
                    }
                    else {
                        HStack {
                            Image(systemName: "triangle.fill")
                                .offset(x: 198, y: -45)
                                .foregroundColor(.green)
                            Text("%" + " " + percentLabel)
                                .offset(x: 198, y: -45)
                                .foregroundColor(.green).opacity(0.7)
                            Text("|" + " " + "24H")
                                .offset(x: 195, y: -46)
                                .foregroundColor(.green).opacity(0.7)
                        }
                        .offset(x: 6)
                    }
                    
                }
            }
            .background{
                Color("bg")
                    .ignoresSafeArea()
            }
        }
        .onAppear{
            fetchCoinData()
            fetchMainData()
            callFunc()
    }
    }
    
    func callFunc(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
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
                let cap = marketInfo.market_data.market_cap
                let currentCap = Double(cap["usd"]!)
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let marketCap = formatter.string(for: currentCap)
                
                capLabel.self = "$" + "\(marketCap!.prefix(6))" + "M"
            }
            catch {
                print("error decoding market data \(error.localizedDescription)")
            }
        }.resume()
        
    }
    
    func fetchCoinData(){
        guard let coinUrl = URL(string: "https://api.binance.com/api/v3/ticker/24hr?symbol=SXPUSDT") else {
            return
        }
        
        URLSession.shared.dataTask(with: coinUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching binance sxp data \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            do{
                let coinInfo = try JSONDecoder().decode(CoinData.self, from: data)
                let coin = coinInfo.lastPrice
                let percent = Double(coinInfo.priceChangePercent)
                
                
                priceLabel.self = String(coin.prefix(6))
                percentLabel.self = String(percent ?? 0.0)
                //percentLabel.self = "0.55"
                
                return self.fetchCoinData()
            }
            catch {
                print("error decoding binance sxp data \(error.localizedDescription)")
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
                supplyLabel.self = "\(supplyString!.prefix(6))" + "M"
                heightLabel.self = heightString!
                burnedLabel.self = "\(burnedString!)" + " " + "SXP"
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
        StatsView(txLabel: "", supplyLabel: "", heightLabel: "", burnedLabel: "", createdLabel: "", priceLabel: "", percentLabel: "", capLabel: "")
    }
}
