//
//  Card.swift
//  Flashzilla
//
//  Created by surya sai on 17/06/24.
//

import Foundation
struct Card :Codable{
    var prompt:String
    var answer:String
    
    static var sampleCard = Card(prompt: "Who Playing superman in Upcoming SUPERMAN?", answer: "David cronsweat")
    
}


