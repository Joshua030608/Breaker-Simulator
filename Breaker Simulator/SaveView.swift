//
//  SaveView.swift
//  Breaker Simulator
//
//  Created by Joshua Ford on 10/21/24.
//
import SwiftUI

struct SaveView: View {
    
    let index: Int
    let goldColor: Color = Color(CGColor(red: 239/255, green: 191/255, blue: 4/255, alpha: 1))
    let wasPlayed = Int.random(in: 0...1) == 0 ? true : false
    let lastPlayedText: String
    @State var saveButtonPressed = false
    
    init(_ index: Int) {
        self.index = index
        lastPlayedText = wasPlayed ? "Last Played on 10/\(Int.random(in: 1...20))/24" : "Never Played"
    }
    
    var body: some View {
        Button {
            print("pressed save button #\(index)")
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
                        Text("Save #\(index)")
                            .foregroundStyle(Color.black)
                            .font(Font.custom("Lilita One", size: 30))
                        if wasPlayed {
                            Button {
                                print("Cleared save #\(index)")
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
            HubView(hasPlayedBefore: wasPlayed)
                .navigationBarBackButtonHidden()
        }
    }
}

