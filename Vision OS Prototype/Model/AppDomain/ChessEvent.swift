//
//  ChessEvent.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 22.01.25.
//

import SwiftUI

class ChessEvent {
    public let guid: UUID = UUID()
    public let game: ChessGame
    public let gameTime: Int
    public let players: (white: Player, black: Player)
    public let clocks: (white: ChessClock, black: ChessClock)
    
    init(game: ChessGame, players: (white: Player, black: Player), gameTime: Int) {
        self.game = game
        self.players = players
        self.gameTime = gameTime
        self.clocks = (.init(startingSeconds: gameTime), .init(startingSeconds: gameTime))
    }
    
    public func declareWinner(color: PieceColor) {
        self.clocks.black.stop()
        self.clocks.white.stop()
        self.game.declareWinner(color: color)
    }
    
    public func declareDraw() {
        self.clocks.black.stop()
        self.clocks.white.stop()
        self.game.declareDraw()
    }
    
    public func addMove(from origin: ChessBoardField, to target: ChessBoardField) {
        self.game.addMove(from: origin, to: target)
        GameStateChangedNotificationCenter.shared.notifyMove(move: game.moveHistory.last!, eventGuid: self.guid)
    }
}
