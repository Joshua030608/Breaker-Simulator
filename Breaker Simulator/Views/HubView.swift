//
//  HubView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI
import SDWebImageSwiftUI

private enum HubViewType {
    case ranking
    case live
    case upgrades
}

struct HubView: View {
    
    @EnvironmentObject private var viewModel: SaveViewModel
    
    @State private var saveSlot: Int
    @State private var currentView: HubViewType = .live
    
    private let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    private let darkGoldColor: Color = Color(CGColor(red: 173/255, green: 139/255, blue: 3/255, alpha: 1))
    private let transparentColor: Color = Color(CGColor(red: 1, green: 1, blue: 1, alpha: 0))
    
    func determineImageName(index: Int) -> String {
        if index == 2 {
            return "arrow.up.square.fill"
        } else if index == 1 {
            return "camera.fill"
        } else {
            return "list.number"
        }
    }
    
    func determineColor(index: Int) -> Color {
        let indexesForType: [HubViewType: Int] = [.ranking: 0, .live: 1, .upgrades: 2]
        return index == indexesForType[currentView] ? .blue : .gray
    }
    
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
                        BarButtonView(type: .back)
                        Spacer()
                        BarButtonView(type: .settings)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    
                    switch currentView {
                        
                    case .ranking:
                        //RankingView()
                        LiveView(save: viewModel.saveSlots[saveSlot])
                    case .live:
                        LiveView(save: viewModel.saveSlots[saveSlot])
                    case .upgrades:
                        //UpgradesView()
                        LiveView(save: viewModel.saveSlots[saveSlot])
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(0..<3) { index in
                            Button {
                                switch index {
                                case 0: currentView = .ranking
                                case 1: currentView = .live
                                case 2: currentView = .upgrades
                                default: break
                                }
                            } label: {
                                VStack {
                                    Image(systemName: determineImageName(index: index))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .offset(y: 5)
                                        .foregroundColor(determineColor(index: index))
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                    .frame(height: 80)
                    .background(goldColor)
                }
            }
        }.persistentSystemOverlays(.hidden)
    }
}
