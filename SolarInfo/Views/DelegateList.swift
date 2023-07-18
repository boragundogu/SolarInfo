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
}

struct DelegateList_Previews: PreviewProvider {
    static var previews: some View {
        DelegateList(usernameArray: [])
    }
}
