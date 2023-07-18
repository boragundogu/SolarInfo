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
    @State var delegateUsername: String
    @State private var walletData: WalletData?
    @State var balanceLabel = ""
    @State var amounts: String
    @State var inComingArray: [String]
    @State var outGoingArray: [String]
    @State var senderArray: [String]
    @State private var isPopupVisible = false
    @State private var showPlusButton = true
    
    let showPlusButtonKey = "showPlusButtonKey"
    
    var body: some View {
        
        ZStack {
            Color("bg").ignoresSafeArea()
            VStack {
                
                if showPlusButton {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                        .offset(x: 0, y: 260)
                        .onTapGesture {
                            isPopupVisible = true
                            showPlusButton = false
                        }
                }
                Spacer()
                if isPopupVisible {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                        isPopupVisible = false
                        showPlusButton = true
                       }
                    VStack {
                            TextField("asd", text: $walletTF)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        
                        if walletTF.prefix(1) == "S" && walletTF.count == 34 {
                            Button {
                                fetchWallet()
                               fetchIncoming { transactions in
                                    if let transactions = transactions {
                                        self.inComingArray.removeAll()
                                        for transaction in transactions {
                                            for transfer in transaction.asset.transfers {
                                                if transfer.recipientId == self.walletTF {
                                                    let amounts = transfer.amount
                                                    let integerAmounts = Double(amounts)! / 100000000
                                                    let formatter = NumberFormatter()
                                                    formatter.numberStyle = .decimal
                                                    let amountString = formatter.string(for: integerAmounts)
                                                    self.inComingArray.append(amountString!)
                                                    //print(inComingArray)
                                                }
                                            }
                                        }
                                    }
                                }
                                fetchIncoming { sender in
                                    if let sender = sender {
                                        self.senderArray.removeAll()
                                        for senderName in sender {
                                            self.senderArray.append(senderName.sender)
                                        }
                                    }
                                }
                                fetchOutgoing { transactions in
                                    if let transactions = transactions {
                                        self.outGoingArray.removeAll()
                                        for transaction in transactions {
                                            for transfer in transaction.asset.transfers {
                                                    let amounts = transfer.amount
                                                    let integerAmounts = Double(amounts)! / 100000000
                                                    let formatter = NumberFormatter()
                                                    formatter.numberStyle = .decimal
                                                    let amountString = formatter.string(for: integerAmounts)
                                                    self.outGoingArray.append(amountString!)
                                            }
                                        }
                                    }
                                }
                                isPopupVisible = false
                                showPlusButton = false
                            } label: {
                                Text("Tamam")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                        }
                    }
                   
                }
                
                VStack(spacing: 0) {
                    if balanceLabel != "" {
                        Text("Balance:" + " " + "\(balanceLabel)" + " " + "SXP")
                            .fontWeight(.light)
                            .foregroundColor(.white)
                        ForEach(senderArray, id: \.self) { sender in
                            Text("\(sender)")
                                .fontWeight(.light)
                                .foregroundColor(.white)
                        }
                    }
                     Text(addressLabel)
                         .fontWeight(.light)
                         .foregroundColor(.orange)
                    VStack {
                        ForEach(inComingArray, id: \.self) { outAmount in
                             Text("+"+"\(outAmount)" + " " + "SXP")
                                 .fontWeight(.light)
                                 .foregroundColor(.green)
                         }
                    }
                    
                 }
                .padding()
                
            }
        }
    }
    
    func fetchOutgoing(completion: @escaping ([OutData]?) -> Void){
        
        let choosenWallet = walletTF
        
        guard let urlOut = URL(string: "https://api.solar.org/api/wallets/" + "\(choosenWallet)" + "/transactions/sent?page=1&limit=5") else {
            return
        }
        
        URLSession.shared.dataTask(with: urlOut) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching outgoing wallet data \(error?.localizedDescription ?? "error") ")
                return
            }
            do {
                let outData = try JSONDecoder().decode(OutgoingData.self, from: data)
                let transactions = outData.data
                completion(transactions)
            }
            catch {
                print("error decoding outgoing wallet data \(error.localizedDescription)")
            }
        }.resume()
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
                let dataValue = try JSONDecoder().decode(IncomingData.self, from: data)
                let transactions = dataValue.data
                completion(transactions)

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
//                self.delegateUsername = walletInfo.data.attributes.delegate.username
//                print(delegateUsername)
                let balance = Int(walletInfo.data.balance)! / 100000000
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let balanceString = formatter.string(for: balance)
                balanceLabel.self = balanceString!
                
                return self.fetchWallet()
        
                
            }
            catch {
                print("error decoding wallet data \(error.localizedDescription)")
            }
        }.resume()
    }
}





struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(walletTF: "", addressLabel: "", delegateUsername: "", amounts: "", inComingArray: [], outGoingArray: [], senderArray: [])
    }
}
