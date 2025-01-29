//
//  ChessBoardView.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//
import SwiftUI
import RealityKit

struct MainMenuView: View {
//    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
//    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
//
//    @State private var isImmersiveSpaceOpen = false
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var windowOpen: Bool = false
    
    let appModel: AppModel
    let events: [GameSelectionItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Verfügbare Spiele")
                .font(.system(size: 13.6 * 6.5))
                .padding(.horizontal, 13.6 * 2.5)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack() {
                    ForEach(events) { event in
                        event
                            .hoverEffect { effect, isActive, _ in
                                effect.scaleEffect(!isActive ? 1.0 : 1.1)
                            }
                    }
                }
            }
        }
    }
}

#Preview() {
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
        
    MainMenuView(appModel: AppModel(), events: items)
}

//Button(isImmersiveSpaceOpen ? "Stop" : "Start") {
//    Task {
//        if isImmersiveSpaceOpen {
//            await dismissImmersiveSpace()
//        } else {
//            await openImmersiveSpace(id: "ChessBoard3DView")
//        }
//        isImmersiveSpaceOpen.toggle()
//    }
//}
