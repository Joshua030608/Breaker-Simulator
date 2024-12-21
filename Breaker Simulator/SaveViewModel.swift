//
//  SaveViewModel.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 12/20/24.
//

import Foundation

struct SaveSlot: Codable, Identifiable {
    let id: Int
    var wasPlayed: Bool
    var lastPlayed: Date?
    var money: Int
    var followers: Int
    var currentPackTier: PackAlpha
}

class SaveViewModel: ObservableObject {
    @Published var saveSlots: [SaveSlot] = []
    private let saveKey = "SaveSlots"
    
    init() {
        loadSaveSlots()
    }
    
    func loadSaveSlots() {
        if let data = UserDefaults.standard.data(forKey: saveKey), let decoded = try? JSONDecoder().decode([SaveSlot].self, from: data) {
            self.saveSlots = decoded
        } else {
            self.saveSlots = (1...4).map { SaveSlot(id: $0, wasPlayed: false, lastPlayed: nil, money: 0, followers: 0, currentPackTier: .bronze) }
            saveSaveSlots()
        }
    }
    
    func saveSaveSlots() {
        if let encoded = try? JSONEncoder().encode(saveSlots) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func updateSaveSlots(id: Int, newSave: SaveSlot) {
        if let index = saveSlots.firstIndex(where: { $0.id == id }) {
            saveSlots[index] = newSave
            saveSaveSlots()
        }
    }
    
    func clearSaveSlots(id: Int) {
        if let index = saveSlots.firstIndex(where: { $0.id == id }) {
            saveSlots[index].wasPlayed = false
            saveSlots[index].lastPlayed = nil
            saveSaveSlots()
        }
    }
}
