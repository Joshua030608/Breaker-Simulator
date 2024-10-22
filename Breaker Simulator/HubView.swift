//
//  HubView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI

enum HubViewType {
    case live
    case inventory
    case shipping
}

struct HubView: View {
    @State var hasPlayedBefore: Bool
    
    let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    let darkGoldColor: Color = Color(CGColor(red: 173/255, green: 139/255, blue: 3/255, alpha: 1))
    @State var currentView: HubViewType = .live
    
    init(hasPlayedBefore: Bool) {
        self.hasPlayedBefore = hasPlayedBefore
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
                    default: EmptyView()
                    }
                }
            }
        }
    }
}
