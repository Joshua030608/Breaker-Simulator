//
//  SaveViewModel.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 12/20/24.
//

import Foundation

class SaveViewModel: ObservableObject {
    @Published var saveSlots: [SaveSlot] = []
    private let fileName = "document.json"
    
    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
    
    init() {
        loadSaveSlots()
        print("Number of SaveSlots: \(saveSlots.count)")
    }
    
    private func loadSaveSlots() {
        guard let url = fileURL else { return }
        
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([SaveSlot].self, from: data)
                self.saveSlots = decoded
            } else {
                self.saveSlots = (0...3).map { SaveSlot.generateBlankSave(id: $0) }
                saveSaveSlots()
            }
        } catch {
            print("Failed to load save slots: \(error.localizedDescription)")
            saveSaveSlots()
        }
    }
    
    private func saveSaveSlots() {
        guard let url = fileURL else { return }
        
        do {
            let encoded = try JSONEncoder().encode(self.saveSlots)
            try encoded.write(to: url)
        } catch {
            print("Failed to save save slots: \(error.localizedDescription)")
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
            saveSlots[index] = SaveSlot.generateBlankSave(id: id)
            saveSaveSlots()
        }
    }
}
