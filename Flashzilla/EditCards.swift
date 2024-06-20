//
//  EditCards.swift
//  Flashzilla
//
//  Created by surya sai on 19/06/24.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @State var cards = [Card]()
    @State var newPrompt = ""
    @State var newAnswer = ""
    var body: some View {
        NavigationStack {
            List {
                Section("Add New Card") {
                    TextField("Prompt",text: $newPrompt)
                    TextField("Answer",text: $newAnswer)
                    Button("Add Card",action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count,id:\.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                            
                            }
                        
                    }
                    .onDelete(perform: { indexSet in
                        cards.remove(atOffsets: indexSet)
                        SaveData()
                    })
                }
                
                
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done",action: done)
            }
            .onAppear(perform: loadData)
            
        }
    }
    func done() {
        dismiss()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    func SaveData() {
        if let data = try? JSONEncoder().encode(cards)  {
            UserDefaults.standard.setValue(data, forKey:"Cards" )
        }
    }
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard !trimmedAnswer.isEmpty && !trimmedPrompt.isEmpty else {return}
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at:0)
        SaveData()
        newPrompt = ""
        newAnswer = ""
    }
}

#Preview {
    EditCards()
}
