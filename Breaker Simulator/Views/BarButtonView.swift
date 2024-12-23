//
//  BarButtonView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/22/24.
//

import SwiftUI

enum BarButtonViewType: CaseIterable {
    
    static let allCases: [BarButtonViewType] = [.back, .settings]
    
    case back
    case settings
}

struct BarButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let type: BarButtonViewType
    @State private var settingsButtonPressed = false
    
    init (type: BarButtonViewType) {
        self.type = type
    }
    
    var body: some View {
        switch type {
            case .settings:
            Button {
                settingsButtonPressed.toggle()
            } label: {
                Image(systemName: "gear.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
                .padding(.trailing, 20)
                .padding(.top, 50)
                .offset(x: 165, y: -35)
                .navigationDestination(isPresented: $settingsButtonPressed) {
                    SettingsView()
                        .navigationBarBackButtonHidden()
                }
            case .back:
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
                .padding(.leading, 20)
                .padding(.top, 50)
                .offset(x: -165, y: -35)
        }
    }
    
}
