//
//  LiveView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 12/20/24.
//

import SwiftUI
import SDWebImageSwiftUI

fileprivate enum Gif: String {
    case bear = "bear.gif"
    case pack = "pack.gif"
    case goodCard = "goodCard.gif"
    case badCard = "badCard.gif"
}

enum PackAlpha: Double, Codable {
    case bronze = 2.5
    case silver = 2.0
    case gold = 1.5
    case hobby = 1.01
}

struct LiveView: View {
    
    @EnvironmentObject var viewModel: SaveViewModel
    @State private var save: SaveSlot
    
    //@State private var followers = 0
    @State private var followersToGain = 0
    @State private var followerString = ""
    
    //@State private var currentPackTier: PackAlpha = .bronze
    @State private var packString: AttributedString
    
    @State private var currentGif: Gif = Gif.bear
    @State private var isProcessing = false
    
    static private let packColors: [String: Color] = [
        "BRONZE": Color(CGColor(red: 205/255, green: 127/255, blue: 50/255, alpha: 1)),
        "SILVER": Color(CGColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)),
        "GOLD": Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1)),
        "HOBBY": Color(CGColor(red: 185/255, green: 242/255, blue: 255/255, alpha: 1))
    ]
    
    static func createAttributedString(from string: String) -> AttributedString {
        var attributedString = AttributedString(string)
        
        // Define the range for [TIER]
        let components = string.split(separator: " ")
        
        let tier = String(components[1])
        
        // Find the range of the tier in the string
        if let range = attributedString.range(of: tier) {
            if let tierColor = LiveView.packColors[tier] {
                attributedString[range].foregroundColor = tierColor
            }
        }
        
        return attributedString
    }
    
    func generateBiasedRandomNumber(max: Int = 10_000, alpha: Double = 2.0) -> Int {
        precondition(alpha > 1, "Alpha must be greater than 1 to skew towards lower numbers.")
        if alpha != 1.01 {
            let u = Double.random(in: 0..<1)
            let biased = pow(u, alpha)
            let n = Int(biased * Double(max)) + 1
            return min(n, max)
        } else {
            return 10_000
        }
    }
    
    func openPack() {
        guard currentGif == Gif.bear, !isProcessing else {
                return
            }
            
            isProcessing = true
            currentGif = Gif.pack
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
            followersToGain = generateBiasedRandomNumber(alpha: save.currentPackTier.rawValue)
            print("Followers to Gain: \(followersToGain)")
            currentGif = (followersToGain >= 2000) ? Gif.goodCard : Gif.badCard
            save.followers = save.followers + followersToGain
            followerString = "You Gained \(followersToGain) Followers!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
                currentGif = Gif.bear
                followerString = "You currently have \n\(save.followers) Followers!"
                if save.followers >= 15_000 {
                    packString = LiveView.createAttributedString(from: "Open HOBBY Pack!")
                    save.currentPackTier = PackAlpha.hobby
                } else if save.followers >= 10_000 {
                    packString = LiveView.createAttributedString(from: "Open GOLD Pack!")
                    save.currentPackTier = PackAlpha.gold
                } else if save.followers >= 5_000 {
                    packString = LiveView.createAttributedString(from: "Open SILVER Pack!")
                    save.currentPackTier = PackAlpha.silver
                } else {
                    packString = LiveView.createAttributedString(from: "Open BRONZE Pack!")
                    save.currentPackTier = PackAlpha.bronze
                }
                viewModel.updateSaveSlots(id: save.id, newSave: save)
                isProcessing = false
            }
        }
    }
    
    init(save: SaveSlot) {
        self.save = save
        if save.followers >= 15_000 {
            self.packString = LiveView.createAttributedString(from: "Open HOBBY Pack!")
        } else if save.followers >= 10_000 {
            self.packString = LiveView.createAttributedString(from: "Open GOLD Pack!")
        } else if save.followers >= 5_000 {
            self.packString = LiveView.createAttributedString(from: "Open SILVER Pack!")
        } else {
            self.packString = LiveView.createAttributedString(from: "Open BRONZE Pack!")
        }
    }
    
    var body: some View {
        AnimatedImage(name: currentGif.rawValue)
            .resizable()
            .frame(width: 320, height: 180)
            .padding(.bottom, 50)
        
        Button {
            openPack()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(Color.white)
                    .frame(width: 400, height: 80)
                HStack {
                    Image("pack")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(packString)
                        .foregroundStyle(Color.black)
                        .font(Font.custom("Lilita One", size: 30))
                }
            }
        }.padding(.bottom, 50)
        
        ZStack {
            if followerString != "" {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(Color.white)
                    .frame(width: 400, height: 80)
                Text(followerString)
                    .foregroundStyle(Color.black)
                    .font(Font.custom("Lilita One", size: 30))
                    .multilineTextAlignment(.center)
            }
        }
        Spacer()
    }
}
