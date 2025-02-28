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
    @Environment(AppModel.self) private var model
    
    @State var activeView: AppView = .EventSelection
    
    var body: some View {
        VStack{
            NavigationStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack() {
                        ForEach(appModel.availableStreams, id: \.guid) { stream in
                            NavigationLink(value: stream.guid) {
                                StreamSelectionItemView(stream: stream)
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
                    let stream = appModel.availableStreams.first(where: { $0.guid == screen })
                    if (stream == nil) { Text("No matching event found! 🥺") }
                    else {
                        let vm = ChessEventStreamViewModel(stream: stream!)
                        ChessEventView(viewModel: vm)
                    }
                }
            }
//            Button("Video") {
//                Task {
//                    openWindow(id: "multiview")
//                }
//            }
        }
    }
}

#Preview {
    let games = [
        DummyData.generateRandomGame(),
        DummyData.generateRandomGame(),
        DummyData.generateRandomGame()
    ]
    
    let players = [
        (white: DummyData.players.randomElement()!, black: DummyData.players.randomElement()!),
        (white: DummyData.players.randomElement()!, black: DummyData.players.randomElement()!),
        (white: DummyData.players.randomElement()!, black: DummyData.players.randomElement()!)
    ]
    
    let events = [
        ChessEvent(game: games[0], players: players[0], gameTime: 300),
        ChessEvent(game: games[1], players: players[1], gameTime: 300),
        ChessEvent(game: games[2], players: players[2], gameTime: 300),
    ]
    
    let streams = events.map { event in ChessEventStream(event: event) }
    
    let items = [
        StreamSelectionItemView(stream: streams[0]),
        StreamSelectionItemView(stream: streams[1]),
        StreamSelectionItemView(stream: streams[2])
    ]
    
    var model = AppModel()
    
    MainWindow(appModel: AppModel())
}
