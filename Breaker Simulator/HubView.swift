//
//  HubView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI
import SDWebImageSwiftUI

fileprivate enum HubViewType {
    case live
    case inventory
    case shipping
}

struct HubView: View {
    
    @EnvironmentObject var viewModel: SaveViewModel
    
    @State private var saveSlot: Int
    @State private var currentView: HubViewType = .live
    
    private let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    private let darkGoldColor: Color = Color(CGColor(red: 173/255, green: 139/255, blue: 3/255, alpha: 1))
    private let transparentColor: Color = Color(CGColor(red: 1, green: 1, blue: 1, alpha: 0))
    
    init(saveSlot: Int) {
        self.saveSlot = saveSlot
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        ForEach(0..<2) { index in
                            BarButton(type: .allCases[index])
                        }
                    }
                    
                    switch currentView {
                        
                    case .live:
                        LiveView(save: viewModel.saveSlots[saveSlot])
                    case .inventory:
                        //InventoryView()
                        EmptyView()
                    case .shipping:
                        //ShippingView()
                        EmptyView()
                        
                    }
                    
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
                }
            }
        }
    }
}
