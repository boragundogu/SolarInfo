//
//  WalletView.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.05.2023.
//

import SwiftUI


struct WalletView: View {
    
    @Namespace var animation
    
    @ObservedObject var walletViewModel = WalletViewModel()
    
    @State var walletTF: String
    @State var addressLabel : String
    @State private var walletData: WalletData?
    @State var balanceLabel = ""
    @State var amounts: String
    @State var inComingArray: [String]
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
                                walletViewModel.fetchWallet(choosenWallet: self.walletTF) { adress, balance in
                                    self.addressLabel = adress
                                    self.balanceLabel = balance
                                }
                                walletViewModel.fetchIncoming(choosenWallet: self.walletTF) {  transactions in
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
                                                    self.inComingArray.append(String(amountString!.prefix(4)))
                                                    //print(inComingArray)
                                                }
                                            }
                                        }
                                    }
                                }
                                walletViewModel.fetchIncoming(choosenWallet: self.walletTF) {  sender in
                                    if let sender = sender {
                                        self.senderArray.removeAll()
                                        for senderName in sender {
                                            self.senderArray.append(senderName.sender)
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
                    if self.balanceLabel != "" {
                        CardView(animation: _animation, adressLabel: $addressLabel, balanceLabel: $balanceLabel, incomingArray: $inComingArray, senderArray: $senderArray)
                    }      
                 }
            }
        }
    }
}





struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(walletTF: "", addressLabel: "", amounts: "", inComingArray: [], senderArray: [])
    }
}
