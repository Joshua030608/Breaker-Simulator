//
//  SaveView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI

struct SaveView: View {
    @EnvironmentObject var viewModel: SaveViewModel
    
    private let save: SaveSlot
    private let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    private let lastPlayedText: String
    @State private var saveButtonPressed = false
    
    static private func formatLastPlayedText(save: SaveSlot) -> String {
        if save.lastPlayed != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            return "Last Played on \(formatter.string(from: save.lastPlayed!))"
        } else {
            return "Never Played"
        }
    }
    
    init(save: SaveSlot) {
        self.save = save
        self.lastPlayedText = SaveView.formatLastPlayedText(save: self.save)
    }
    
    var body: some View {
        Button {
            print("pressed save button #\(save.id)")
            let newSave = SaveSlot(id: save.id, wasPlayed: true, lastPlayed: Date(), money: save.money, followers: save.followers, currentPackTier: save.currentPackTier)
            viewModel.updateSaveSlots(id: save.id, newSave: newSave)
            saveButtonPressed = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 50)
                VStack {
                    HStack {
                        Image("save_icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Save #\(save.id)")
                            .foregroundStyle(Color.black)
                            .font(Font.custom("Lilita One", size: 30))
                        if save.wasPlayed {
                            Button {
                                print("Cleared save #\(save.id)")
                                viewModel.clearSaveSlots(id: save.id)
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                    Text(lastPlayedText)
                        .foregroundStyle(Color.black)
                        .font(Font.custom("Lilita One", size: 20))
                }
            }
        }.navigationDestination(isPresented: $saveButtonPressed) {
            HubView(saveSlot: save.id)
                .navigationBarBackButtonHidden()
        }
    }
}

