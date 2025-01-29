//
//  AppModel.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 12.11.24.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var eventOpen: Bool = false
    var showingLiveStream: Bool = false
    var showing3DChessBoard: Bool = false
    
    var chessEvents: [ChessEvent] = []
    
    init() {
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

        self.chessEvents = events
    }
}
