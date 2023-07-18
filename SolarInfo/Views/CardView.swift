//
//  CardView.swift
//  SolarInfo
//
//  Created by Bora Gündoğu on 16.07.2023.
//

import SwiftUI

struct CardView: View {
    
    @State var card: [Card] = [
        .init(cardImage: "card"),
        .init(cardImage: "card")
    ]
    
    //MARK: Aniamsyon Özellikleri
    @Namespace var animation
    @State var selectedCard: Card?
    @State var showDetail: Bool = false
    @State var showDetailContent: Bool = false
    @State var showTransactions: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome!")
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Total Balance;")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
        
                Text("$2,142.35")
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            .padding(15)
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            CardsScrollView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .top)
        .opacity(showDetail ? 0 : 1)
        .background{
            Color("mainbg")
                .ignoresSafeArea()
        }
        .overlay{
            if let selectedCard,showDetail{
                DetailView(card: selectedCard)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 1)))
                
            }
        }
    }
    
    @ViewBuilder
    func CardsScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(card){ card in
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        if selectedCard?.id == card.id && showDetail {
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(width: size.width, height: size.height)
                        }
                        else {
                            Image(card.cardImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                    
                                .matchedGeometryEffect(id: card.id, in: animation)
                            
                            
                                .rotationEffect(.init(degrees: 90))
                                //MARK: Yükseklik ve genişliği size'a göre belirtme.
                                .frame(width: size.height, height: size.width)
                                //MARK: Ortalama
                                .frame(width: size.width, height: size.height)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        selectedCard = card
                                        showDetail = true
                                    }
                                }
                        }
                    }
                    .frame(width: 300)
                }
            }
            .padding(15)
            
        }
    }
    
    //MARK: Detay View
    @ViewBuilder
    func DetailView(card: Card) -> some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)){
                        showDetailContent = false
                        showTransactions = false
                    }
                    withAnimation(.easeInOut(duration: 0.5).delay(0.05)){
                        showDetail =  false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                Text("Back")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding(.bottom, 15)
            .opacity(showDetailContent ? 1 : 0)
            
            Image(card.cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: card.id, in: animation)
                .rotationEffect(.init(degrees: showDetailContent ? 0 : 90))
                .frame(height: 220)
            
            ExpenseView()
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear{
            withAnimation(.easeInOut(duration: 0.5)) {
                showDetailContent = true
            }
            withAnimation(.easeInOut.delay(0.1)) {
                showTransactions = true
            }
        }
    }
    
    //MARK: Expense
    @ViewBuilder
    func ExpenseView()->some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20){
                    ForEach(card) { card in
                        TransactionCardView(transaction: card)
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .background{
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.white)
            }
            .offset(y: showTransactions ? 0 : size.height + 50)
        }
        .padding(.top)
        .padding(.horizontal, 10)
    }
}

struct TransactionCardView: View{
    
    var transaction: Card
    
    var body: some View{
        HStack(spacing: 14){
            Text("From:" + " " + "SUGskkbg")
                .foregroundColor(.black)
            Image(systemName: "arrow.up.forward")
                .foregroundColor(.green)
            Text("Amount:" + " " + "+8.99 SXP")
                .foregroundColor(.green)
            Text("Fee:" + " " + "0.18 SXP")
                .foregroundColor(.black)
        }
        .padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
