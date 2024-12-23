//
//  SettingsView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 12/20/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: SaveViewModel
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            VStack {
                HStack {
                    ForEach(0..<2) { index in
                        if index == 1 {
                            BarButtonView(type: .allCases[index])
                            .hidden()
                        } else {
                            BarButtonView(type: .allCases[index])
                        }
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundStyle(Color.white)
                        .frame(width: 400, height: 80)
                    Text("What could you possibly \nneed to change?")
                        .foregroundStyle(Color.black)
                        .font(Font.custom("Lilita One", size: 30))
                        .multilineTextAlignment(.center)
                }.padding(.top, 60)
                
                Spacer()
            }
        }
    }
}
