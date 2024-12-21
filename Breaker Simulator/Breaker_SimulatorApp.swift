//
//  Breaker_SimulatorApp.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/20/24.
//

import SwiftUI

@main
struct Breaker_SimulatorApp: App {
    @StateObject private var viewModel = SaveViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
