//
//  SplashView.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 10.07.2023.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack{
            if self.isActive {
                Home()
            }
            else {
                Color("mainbg").ignoresSafeArea()
            VStack {
                VStack{
                    Image("solar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
            }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                withAnimation {
                    isActive = true
                }
                
            }
        }
    }
    }

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
