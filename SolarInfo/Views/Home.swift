//
//  Home.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 16.05.2023.
//

import SwiftUI

struct Home: View {
    
    @State private var activeTab: Tab = .info
    
    @Namespace private var animation
    
    var body: some View {
        ZStack {
           Color("mainbg").ignoresSafeArea()
            VStack(spacing: 0) {
                    TabView(selection: $activeTab) {
                        StatsView(txLabel: "", supplyLabel: "", heightLabel: "", burnedLabel: "", priceLabel: "", percentLabel: "", capLabel: "", doublePrice: 0.0, doubleSupply: 0.0)
                        //Text("Home")
                            .tag(Tab.info)
                            .toolbar(.hidden, for: .tabBar)
                        WalletView(walletTF: "", addressLabel: "", delegateUsername: "", balanceLabel: "", amounts: "", inComingArray: [], senderArray: [])
                        //Text("Services")
                            .tag(Tab.wallet)
                            .toolbar(.hidden, for: .tabBar)
                        CardView()
                            .tag(Tab.others)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    
                    CustomTabBar()
            }
        }
    }
    
    @ViewBuilder
    func CustomTabBar(_ tint: Color = Color("Orange"), _ inactiveTint: Color = .orange) -> some View {
        HStack(alignment: .bottom,spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(tint: tint, inactiveTint: inactiveTint, tab: $0, animation: animation, activeTab: $activeTab)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 5){
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            activeTab = tab
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
