//
//  CardView.swift
//  Flashzilla
//
//  Created by surya sai on 17/06/24.
//

import SwiftUI

struct CardView: View {
    let card:Card
    @State var isShowingAnswer = false
    @State var scaleAmount = 1.0
    @State var offset = CGSize.zero
    
    var removal:(()->Void)? = nil

    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(.white.opacity(1-abs(offset.width/50.0)))
                .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(offset.width > 0 ? .green:.red)
                )
                .shadow(radius: 10)
            
            VStack  {
                if !isShowingAnswer {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
                
            }
            .padding(20)
        .multilineTextAlignment(.center)
        
         
            
        }

        .frame(width: 450,height: 250)
       .scaleEffect(scaleAmount)
        .rotationEffect(.degrees(offset.width/5.0))
        .offset(x:offset.width*5)
        .opacity(2-Double(abs(offset.width/50)))
        .gesture(
        DragGesture()
            .onChanged {value in
                withAnimation{
                    scaleAmount = 1.3
                    offset = value.translation
                }
                
            }
            .onEnded {_ in
                withAnimation {
                    scaleAmount = 1.0
                    if abs(offset.width) > 100 {
                        removal?()
                    }
                    else {
                        offset = .zero
                    }
               }
            }
            
        
        )
        .onTapGesture {
            withAnimation {
                isShowingAnswer.toggle()
            }
        }
    }
}

#Preview {
    CardView(card: .sampleCard )
}
