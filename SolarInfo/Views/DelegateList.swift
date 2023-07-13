//
//  DelegateList.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 7.06.2023.
//

import SwiftUI

struct DelegateList: View {
    
    @State public var usernameArray: [String]
    
    var body: some View {
        VStack {
            
            Button {
                fetchDelegates { delegates in
                    if let delegates = delegates {
                        self.usernameArray.removeAll()
                        for name in delegates {
                            self.usernameArray.append(name.username)
                            //print(usernameArray)
                        }
                    }
                }
            } label: {
                if usernameArray == [] {
                    Text("List")
                        .padding()
                }
            }
            
            Spacer()
            
            
            List {
                ForEach(usernameArray, id: \.self) { usernames in
                        Text("-" + " " + "\(usernames)")
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                    
                }
            }
        }

    }
    
    func fetchDelegates(completion: @escaping ([DelegateData]?) -> Void) {
        
        guard let delegateUrl = URL(string: "https://api.solar.org/api/delegates?page=1&limit=53") else {
            return
        }
        
        URLSession.shared.dataTask(with: delegateUrl) { data, response, error in
            
            guard let data = data, error == nil else {
                print("error fetching delegate data \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            do {
                let delegateInfo = try JSONDecoder().decode(Delegate.self, from: data)
                let dlgData = delegateInfo.data
                completion(dlgData)
                
            }
            catch {
                print("error decoding data \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct DelegateList_Previews: PreviewProvider {
    static var previews: some View {
        DelegateList(usernameArray: [])
    }
}
