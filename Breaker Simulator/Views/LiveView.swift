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

struct LiveView: View {
    
    @EnvironmentObject private var viewModel: SaveViewModel
    @State private var save: SaveSlot
    
    @State private var followersToGain = 0
    @State private var followerString = ""
    
    @State private var packString: AttributedString
    
    @State private var currentGif: Gif = Gif.bear
    @State private var isProcessing = false
    
    private static func createAttributedString(from string: String) -> AttributedString {
        var attributedString = AttributedString(string)
        
        let components = string.split(separator: " ")
        
        let tier = String(components[1])
        
        if let range = attributedString.range(of: tier) {
            if let tierColor = PackAlpha.packColors[tier] {
                attributedString[range].foregroundColor = tierColor
            }
        }
        
        return attributedString
    }
    
    private func generateBiasedRandomNumber(max: Int = 10_000, alpha: Double = 2.0) -> Int {
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
    
    static private func determineCorrectStringAndPackTier(save: SaveSlot) -> (AttributedString, PackAlpha) {
        var toReturn: (AttributedString, PackAlpha) = ("", PackAlpha.bronze)
        if save.followers >= 15_000 {
            toReturn.0 = LiveView.createAttributedString(from: "Open HOBBY Pack!")
            toReturn.1 = PackAlpha.hobby
        } else if save.followers >= 10_000 {
            toReturn.0 = LiveView.createAttributedString(from: "Open GOLD Pack!")
            toReturn.1 = PackAlpha.gold
        } else if save.followers >= 5_000 {
            toReturn.0 = LiveView.createAttributedString(from: "Open SILVER Pack!")
            toReturn.1 = PackAlpha.silver
        } else {
            toReturn.0 = LiveView.createAttributedString(from: "Open BRONZE Pack!")
            toReturn.1 = PackAlpha.bronze
        }
        print(#function + "Current Followers: \(save.followers) \nCurrent PackTier: \(toReturn.1) \nCurrent String: \(toReturn.0)")
        return toReturn
    }
    
    private func openPack() {
        guard currentGif == Gif.bear, !isProcessing else {
            return
        }
        
        isProcessing = true
        currentGif = Gif.pack
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
            followersToGain = generateBiasedRandomNumber(alpha: save.currentPackTier.rawValue)
            currentGif = (followersToGain >= 2000) ? Gif.goodCard : Gif.badCard
            save.followers = save.followers + followersToGain
            followerString = "You Gained \(followersToGain) Followers!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
                currentGif = Gif.bear
                followerString = "You currently have \n\(save.followers) Followers!"
                let newValues = LiveView.determineCorrectStringAndPackTier(save: self.save)
                packString = newValues.0
                save.currentPackTier = newValues.1
                viewModel.updateSaveSlots(id: save.id, newSave: save)
                isProcessing = false
            }
        }
    }
    
    init(save: SaveSlot) {
        self.save = save
        self.packString = LiveView.determineCorrectStringAndPackTier(save: save).0
        print(#function + "Current Followers: \(save.followers)")
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
                    .frame(width: 370, height: 80)
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
                    .frame(width: 370, height: 80)
                Text(followerString)
                    .foregroundStyle(Color.black)
                    .font(Font.custom("Lilita One", size: 30))
                    .multilineTextAlignment(.center)
            }
        }
        Spacer()
    }
}
