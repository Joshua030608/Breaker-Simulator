//
//  SaveSlot.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 12/21/24.
//

import SwiftUI

struct SaveSlot: Codable, Identifiable {
    let id: Int
    var wasPlayed: Bool
    var lastPlayed: Date?
    var money: Int
    var followers: Int
    var currentPackTier: PackAlpha
    
    static func generateBlankSave(id: Int) -> SaveSlot {
        return SaveSlot(id: id, wasPlayed: false, lastPlayed: nil, money: 0, followers: 0, currentPackTier: .bronze)
    }
}

enum PackAlpha: Double, Codable {
    case bronze = 2.5
    case silver = 2.0
    case gold = 1.5
    case hobby = 1.01
    
    static let packColors: [String: Color] = [
        "BRONZE": Color(CGColor(red: 205/255, green: 127/255, blue: 50/255, alpha: 1)),
        "SILVER": Color(CGColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)),
        "GOLD": Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1)),
        "HOBBY": Color(CGColor(red: 185/255, green: 242/255, blue: 255/255, alpha: 1))
    ]
}
