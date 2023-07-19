//
//  WalletViewModel.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 19.07.2023.
//

import Foundation

class WalletViewModel: ObservableObject{
    
    var choosenWallet: String = ""
    var balanceValue: String = ""
    var adressValue: String = ""
    
    
    func fetchIncoming(choosenWallet: String,completion: @escaping ([DataValue]?) -> Void){
        
       let choosenWallet = choosenWallet
        
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
    
    func fetchWallet(choosenWallet: String,balanceValue: String, adressValue: String){
        
        let choosenWallet = choosenWallet
        
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
                self.adressValue = walletInfo.data.address
                let balance = Int(walletInfo.data.balance)! / 100000000
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let balanceString = formatter.string(for: balance)
                self.balanceValue = balanceString!
                
                return self.fetchWallet(choosenWallet: self.choosenWallet, balanceValue: self.balanceValue, adressValue: self.adressValue)
        
                
            }
            catch {
                print("error decoding wallet data \(error.localizedDescription)")
            }
        }.resume()
    }
}
