//
//  ContentView.swift
//  MemoryGame
//
//  Created by Rüzgar cem Türkmen on 8.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var cards = ["🍎", "🍌", "🍇", "🍑", "🍓", "🍐"]
        @State private var shuffledCards: [String] = []
        @State private var selectedCards: [Int] = []
        @State private var matchedCards: [Int] = []
    
    @State private var gameWon:Bool = false
    var body: some View {
        VStack {
            Text("Memory Card")
                .font(.largeTitle.bold())
                .padding()
            
            //GridStack + GridStack
            GridStack(rows: 2, colums: 6) { row, col in
                let index = row * 6 + col
                if index < shuffledCards.count {
                    return AnyView(
            CardView(symbol: self.shuffledCards[index], isFlipped: self.selectedCards.contains(index) || self.matchedCards.contains(index)) // Kart görünümü
                                   
            
                .onTapGesture {
                    withAnimation(.smooth){
                        self.cardTapped(index: index) // Kart tıklama
                    }
                }
                    )
                }else{
                    return AnyView(EmptyView())
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius:20).stroke(Color.purple,lineWidth: 4))
            .padding()
            
            Button("Restart") {
                withAnimation(.smooth){
                    self.restartGame()
                }
            }
            .font(.title2)
            .padding()
            .background(Color.purple)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
        .onAppear(perform:shuffleCards) // ekrana geldiğinde çalışır
        .alert(isPresented: self.$gameWon) {
            Alert(title: Text("You won"),message: Text("Congratulation, you have won the game!"),dismissButton: .default(Text("Play again"),action: {
                withAnimation(.smooth){
                    self.restartGame()
                }
            }))
                
        }
    }
    
    // Kartları karıştır
    func shuffleCards(){
        shuffledCards  = (cards + cards).shuffled()
    }
    
    // Karta tıklandı
    func cardTapped(index:Int){
        if selectedCards.count == 2{
            selectedCards.removeAll()
        }
        
        if !matchedCards.contains(index){
            selectedCards.append(index)
            if selectedCards.count == 2{
                checkForMatch()
            }
        }
    }
    // kart eşleşmesini kontrol ediyor
    func checkForMatch(){
        let firstIndex = selectedCards[0]
        let secondIndex = selectedCards[1]
        if  shuffledCards[firstIndex] == shuffledCards[secondIndex] {
              matchedCards += selectedCards
            if matchedCards.count == shuffledCards.count{
                gameWon = true
            }
        }
    }
    
    func restartGame(){
        matchedCards.removeAll()
        selectedCards.removeAll()
        shuffleCards()
    }
}

#Preview {
    ContentView()
}
// kart
struct CardView:View {
    var symbol:String
    var isFlipped:Bool //Kart açık mı kapalı mı
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(isFlipped ? Color.white : Color.purple)
                .frame(width: 50, height: 70)
                .clipShape(RoundedRectangle(cornerRadius:20))
                .shadow(radius: 5)
                .overlay(
                RoundedRectangle(cornerRadius:20)
                    .stroke(Color.gray,lineWidth: 2)
                )
            if isFlipped{
                Text(symbol)
                    .font(.largeTitle)
                    .transition(.scale) //animasyon
            }
            
        }
    }
}
    
// satır-sutun
struct GridStack:View {
    
    var rows:Int
    var colums:Int
    let content:(Int,Int) -> AnyView
    
    var body: some View {
        
        VStack(spacing:10){
            ForEach(0 ..< rows, id: \.self){row in //satır
                
                HStack(spacing:10){
                    ForEach(0 ..< colums, id: \.self){column in //sutun
                        
                        content(row,column)
                    }
                }
            }
        }
    }
}
