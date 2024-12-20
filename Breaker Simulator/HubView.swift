//
//  HubView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI
import SDWebImageSwiftUI

enum HubViewType {
    case live
    case inventory
    case shipping
}

struct HubView: View {
    @State var hasPlayedBefore: Bool
    @State var currentGif: String = gifStrings[0]
    @State var isProcessing = false
    @State var currentView: HubViewType = .live
    @State var followers = 0
    @State var followersToGain = 0
    @State var followerString = ""
    @State var currentPackTier = packTiers["BRONZE"]!
    @State var packString: AttributedString
    
    let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    let darkGoldColor: Color = Color(CGColor(red: 173/255, green: 139/255, blue: 3/255, alpha: 1))
    let transparentColor: Color = Color(CGColor(red: 1, green: 1, blue: 1, alpha: 0))
    
    static let gifStrings = ["bear.gif", "pack.gif", "goodCard.gif", "badCard.gif"]
    static let packTiers: [String: Double] = ["BRONZE": 2.5, "SILVER": 2, "GOLD": 1.5, "HOBBY": 1.01]
    static let packColors: [String: Color] = [
        "BRONZE": Color(CGColor(red: 205/255, green: 127/255, blue: 50/255, alpha: 1)),
        "SILVER": Color(CGColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)),
        "GOLD": Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1)),
        "HOBBY": Color(CGColor(red: 185/255, green: 242/255, blue: 255/255, alpha: 1))
    ]
    
    init(hasPlayedBefore: Bool) {
        self.hasPlayedBefore = hasPlayedBefore
        self.packString = HubView.createAttributedString(from: "Open BRONZE Pack!")
    }
    
    static func createAttributedString(from string: String) -> AttributedString {
        var attributedString = AttributedString(string)
        
        // Define the range for [TIER]
        let components = string.split(separator: " ")
        
        let tier = String(components[1])
        
        // Find the range of the tier in the string
        if let range = attributedString.range(of: tier) {
            if let tierColor = HubView.packColors[tier] {
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
        guard currentGif == HubView.gifStrings[0], !isProcessing else {
                return
            }
            
            isProcessing = true
            currentGif = HubView.gifStrings[1]
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
            followersToGain = generateBiasedRandomNumber(alpha: currentPackTier)
            print("Followers to Gain: \(followersToGain)")
            currentGif = HubView.gifStrings[(followersToGain >= 2000) ? 2 : 3]
            followers = followers + followersToGain
            followerString = "You Gained \(followersToGain) Followers!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
                currentGif = HubView.gifStrings[0]
                followerString = "You currently have \n\(followers) Followers!"
                if followers >= 15_000 {
                    packString = HubView.createAttributedString(from: "Open HOBBY Pack!")
                    currentPackTier = HubView.packTiers["HOBBY"]!
                } else if followers >= 10_000 {
                    packString = HubView.createAttributedString(from: "Open GOLD Pack!")
                    currentPackTier = HubView.packTiers["GOLD"]!
                } else if followers >= 5_000 {
                    packString = HubView.createAttributedString(from: "Open SILVER Pack!")
                    currentPackTier = HubView.packTiers["SILVER"]!
                } else {
                    packString = HubView.createAttributedString(from: "Open BRONZE Pack!")
                    currentPackTier = HubView.packTiers["BRONZE"]!
                }
                isProcessing = false
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                VStack {
                    switch currentView {
                    case .live:
                        HStack {
                            ForEach(0..<2) { index in
                                BarButton(type: BarButtonType.allCases[index])
                            }
                        }
                        
                        AnimatedImage(name: currentGif)
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
                        ZStack {
                            Rectangle()
                                .ignoresSafeArea()
                                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                                .foregroundStyle(Color(goldColor))
                            Rectangle()
                                .frame(maxWidth: .infinity, minHeight: 15, maxHeight: 15)
                                .offset(y: -32.5)
                                .foregroundStyle(Color(darkGoldColor))
                            ForEach(0..<2) { index in
                                let position = CGFloat((Int(geometry.size.width) * (index + 1)) / 3)
                                Rectangle()
                                    .ignoresSafeArea()
                                    .frame(width: 7, height: 80)
                                    .position(x: position)
                                    .offset(y: 40)
                                    .foregroundStyle(Color(darkGoldColor))
                            }
                            
                            HStack {
                                ForEach(0..<3) { index in
                                    Button {
                                        print("Index \(index) pressed!")
                                    } label: {
                                        Rectangle()
                                            .frame(width: (geometry.size.width) / 3, height: 80)
                                            .position(x: CGFloat((Int(geometry.size.width) * (index)) / 3))
                                            .offset(y: 40)
                                            .foregroundStyle(Color(transparentColor))
                                    }
                                }
                            }
                            //TODO: First button: list of rankings (list?); second button: go live (camera); third button: upgrade (up arrow circle fill)
                        }.frame(maxHeight: 80)
                    default: EmptyView()
                    }
                }
            }
        }
    }
}
