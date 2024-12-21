//
//  BarButton.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/22/24.
//

import SwiftUI

enum BarButtonType: CaseIterable {
    
    static let allCases: [BarButtonType] = [.back, .settings]
    
    case back
    case settings
}

struct BarButton: View {
    @Environment(\.dismiss) private var dismiss
    
    private let type: BarButtonType
    @State private var settingsButtonPressed = false
    
    init (type: BarButtonType) {
        self.type = type
    }
    
    var body: some View {
        switch type {
            case .settings:
            Button {
                print("Settings Pressed")
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
