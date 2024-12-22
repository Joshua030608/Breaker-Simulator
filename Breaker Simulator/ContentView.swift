//
//  ContentView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/20/24.
//

import SwiftUI
import NavigationTransitions

struct ContentView: View {
    @EnvironmentObject private var viewModel: SaveViewModel
    
    private let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(goldColor)
                    .ignoresSafeArea()
                VStack {
                    Text("Select a Save!")
                        .font(Font.custom("Lilita One", size: 50))
                        .foregroundStyle(Color.black)
                        .padding(.bottom, 50)
                    ForEach(viewModel.saveSlots) { save in
                        SaveView(save: save).padding(.bottom, 25)
                    }
                }
            }
        }.navigationTransition(.slide.animation(.easeInOut(duration: 0.3)))
    }
}
