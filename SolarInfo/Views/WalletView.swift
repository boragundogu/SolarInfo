//
//  WalletView.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import SwiftUI

struct WalletView: View {
    
    @State var walletTF: String
    @State var addressLabel : String
    @State private var walletData: WalletData?
    @State var balanceLabel = ""
    @State var amounts: String
    @State var inComingArray: [String]
    @State var outGoingArray: [String]
    
    var body: some View {
        
        ZStack {
            Color("bg").ignoresSafeArea()
            VStack {
                
                    TextField("asd", text: $walletTF)
                        .multilineTextAlignment(.center)
                        .background(Color.white)
                    
                    
                    Button {
                        fetchWallet()
                       fetchIncoming { transactions in
                            if let transactions = transactions {
                                for transaction in transactions {
                                    for transfer in transaction.asset.transfers {
                                        if transfer.recipientId == self.walletTF {
                                            let amounts = transfer.amount
                                            let integerAmounts = Double(amounts)! / 100000000
                                            let formatter = NumberFormatter()
                                            formatter.numberStyle = .decimal
                                            let amountString = formatter.string(for: integerAmounts)
                                            self.inComingArray.append(amountString!)
                                           // print(inComingArray)
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Button")
                    }.padding(80)
                    
                    VStack(spacing: 20) {
                        Text("Balance:" + " " + "\(balanceLabel)" + " " + "SXP")
                            .fontWeight(.light)
                            .foregroundColor(.white)
                        Text(addressLabel)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                        ForEach(inComingArray, id: \.self) { outAmount in
                            Text("+"+"\(outAmount)" + " " + "SXP")
                                .fontWeight(.light)
                                .foregroundColor(.white)
                        }
                    }
            }
        }
    }
    
    
    func fetchIncoming(completion: @escaping ([DataValue]?) -> Void){
        
       let choosenWallet = walletTF
        
        guard let urlIn = URL(string: "https://api.solar.org/api/wallets/" + "\(choosenWallet)" + "/transactions/received?page=1&limit=5") else {
            return
        }
        
        URLSession.shared.dataTask(with: urlIn) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching incoming wallet data \(error?.localizedDescription ?? "error")")
                return
            }
            
            do {
                let dataValue = try JSONDecoder().decode(WalletInOut.self, from: data)
                let transactions = dataValue.data
                completion(transactions)
                //print(transactions)
            }
            catch {
                print("error decoding incoming wallet data \(error.localizedDescription)")
            }
        }.resume()
       
    }

    func fetchWallet(){
        
        let choosenWallet = walletTF
        
        guard let url = URL(string: "https://api.solar.org/api/wallets/" + "\(choosenWallet)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetcing wallet data \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            do {
                let walletInfo = try JSONDecoder().decode(WalletData.self, from: data)
                addressLabel.self = walletInfo.data.address
                let balance = Int(walletInfo.data.balance)! / 100000000
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let balanceString = formatter.string(for: balance)
                balanceLabel.self = balanceString!
        
                
            }
            catch {
                print("error decoding wallet data \(error.localizedDescription)")
            }
        }.resume()
    }
}





struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(walletTF: "", addressLabel: "", balanceLabel: "", amounts: "", inComingArray: [], outGoingArray: [])
    }
}
