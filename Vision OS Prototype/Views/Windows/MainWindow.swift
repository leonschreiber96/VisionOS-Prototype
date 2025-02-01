//
//  MainWindow.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 28.01.25.
//

import SwiftUI

enum NavigationDestinations: String, CaseIterable, Hashable {
    case Details
    case Profiles
    case Settings
}

struct MainWindow: View {
    var appModel: AppModel
    
    @Environment(\.openWindow) private var openWindow
    
    @State var activeView: AppView = .EventSelection
    
    var body: some View {
        VStack{
            NavigationStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack() {
                        ForEach(appModel.chessEvents, id: \.guid) { event in
                            NavigationLink(value: event.guid) {
                                GameSelectionItem(event: event)
                            }
                            .padding(1360*0.02)
                            .buttonStyle(.plain)
                            .hoverEffectDisabled()
                            .scrollClipDisabled()
                            .hoverEffect{ effect, isActive, _ in
                                effect.scaleEffect(!isActive ? 1.0 : 1.05)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Available Chess Events")
                .navigationDestination(for: UUID.self) { screen in
                    let event = appModel.chessEvents.first(where: { $0.guid == screen })
                    if (event == nil) { Text("No matching event found! 🥺") }
                    else {
                        let vm = ChessEventViewModel(event: event!)
                        ChessGameView(viewModel: vm)
                    }
                }
            }
            
            Button("Video") {
                Task {
                    openWindow(id: "multiview")
                }
            }
        }
    }
}

struct SettingsScreen: View {
    var body: some View {
        Text("Settings Screen")
            .navigationTitle("Settings")
    }
}

#Preview {
    let dummyData = DummyData()
    
    let games = [
        dummyData.generateRandomGame(),
        dummyData.generateRandomGame(),
        dummyData.generateRandomGame()
    ]
    
    let players = [
        (white: dummyData.players.randomElement()!, black: dummyData.players.randomElement()!),
        (white: dummyData.players.randomElement()!, black: dummyData.players.randomElement()!),
        (white: dummyData.players.randomElement()!, black: dummyData.players.randomElement()!)
    ]
    
    let events = [
        ChessEvent(game: games[0], players: players[0], gameTime: 300),
        ChessEvent(game: games[1], players: players[1], gameTime: 300),
        ChessEvent(game: games[2], players: players[2], gameTime: 300),
    ]
    
    let items = [
        GameSelectionItem(event: events[0]),
        GameSelectionItem(event: events[1]),
        GameSelectionItem(event: events[2])
    ]
    
    var model = AppModel()
    
    MainWindow(appModel: AppModel())
}
