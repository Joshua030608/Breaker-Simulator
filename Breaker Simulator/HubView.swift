//
//  HubView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI
import SDWebImageSwiftUI

struct HubView: View {
    @State var hasPlayedBefore: Bool
    
    let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    let darkGoldColor: Color = Color(CGColor(red: 173/255, green: 139/255, blue: 3/255, alpha: 1))
    
    init(hasPlayedBefore: Bool) {
        self.hasPlayedBefore = hasPlayedBefore
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                VStack {
                    BackButton()
                        .padding(.leading, 20)
                        .padding(.top, 50)
                        .offset(x: -185, y: -35)
                    //Text("Main Screen")
                    AnimatedImage(name: "cards.gif")
                        .resizable()
                        .frame(width: 200, height: 200)
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
                    }.frame(maxHeight: 80)
                }
            }
        }
    }
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrow.left.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}
