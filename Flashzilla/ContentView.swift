//
//  ContentView.swift
//  Flashzilla
//
//  Created by surya sai on 13/06/24.
//

import SwiftUI

extension View {
    func stackedAt(at position:Int, in total:Int) -> some View {
        let offset = Double(total - position)
        
        return self.offset(y: offset*10)
        
    }
}

struct ContentView: View {
    
    @State var cards = Array<Card>()
    @State var timeRemaining = 100
    let timmer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @State var isActive = false
    @State var showEditScreen = false
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
            
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal,20)
                    .padding()
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    
                ZStack {
                    ForEach(0..<cards.count,id: \.self) { index in
                        
                        CardView(card: cards[index]) {
                         
                                cards.remove(at: index)
                            
                            if cards.isEmpty {
                                isActive = false
                            }
                           
                        }
                            .stackedAt(at: index , in: cards.count)
                            .allowsHitTesting(index == cards.count-1)
                            
                          
                    }
                    .allowsHitTesting(timeRemaining > 0)
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                              
                                showEditScreen = true
                            } label: {
                                Image(systemName: "plus.circle")
                                    .padding()
                                    .background(.black.opacity(0.7))
                                    .clipShape(.circle)
                            }
                        }
                        Spacer()
                    }
                    .foregroundStyle(.gray)
                    .font(.largeTitle)
                    .padding()
                    
                    if cards.isEmpty {
                        Button("Start Again",action: resetCards)
                            .padding()
                            .background(.white)
                            .foregroundStyle(.black)
                            .clipShape(.capsule)
                    }
                }
            }
        }
        .onReceive(timmer){time in
            if timeRemaining > 0 && isActive  {
                timeRemaining -= 1
            }
            
        }
        .onChange(of: scenePhase) {
            
            if scenePhase == .active && !cards.isEmpty {
                isActive = true
            }
            else {
                isActive = false
            }
            
        }
        .sheet(isPresented: $showEditScreen, onDismiss: resetCards, content: {EditCards()})
        .onAppear(perform: resetCards)
    }
    
    func resetCards() {
        loadData()
        timeRemaining = 100
        isActive = true
    }
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
}

#Preview {
    ContentView()
}
