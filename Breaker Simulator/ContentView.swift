//
//  ContentView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/20/24.
//

import SwiftUI

struct ContentView: View {
    
    let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    
    var body: some View {
        ZStack {
            Color(goldColor)
                .ignoresSafeArea()
            VStack {
                Text("Select a Save!")
                    .font(Font.custom("Lilita One", size: 50))
                    .foregroundStyle(Color.black)
                    .padding(.bottom, 50)
                ForEach(1..<5) { index in
                    SaveView(index).padding(.bottom, 25)
                }
            }
        }
    }
}
