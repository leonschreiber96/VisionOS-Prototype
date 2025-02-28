//
//  ChessEvent.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 22.01.25.
//

import SwiftUI

/**
 Represents a streamable chess event.
 An event is associated with a chess game, but also contains metadata about it (information about the players, the time control limit of the game and the chess clock objects)
 */
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
    
    /// Declares one color (black or white) as the winner of the game. Stops all clocks.
    public func declareWinner(color: PieceColor) {
        self.clocks.black.stop()
        self.clocks.white.stop()
        self.game.declareWinner(color: color)
    }
    
    /// Declares a draw as the game result. Stops all clocks.
    public func declareDraw() {
        self.clocks.black.stop()
        self.clocks.white.stop()
        self.game.declareDraw()
    }
    
    /// Adds a `ChessMove` with the specified origin and target to the game's move history.
    /// **Notifies all listeners who have subscribed to this event's game state updates.**
    public func addMove(from origin: ChessBoardField, to target: ChessBoardField) {
        self.game.addMove(from: origin, to: target)
        GameStateChangedNotificationCenter.shared.notifyMove(move: game.moveHistory.last!, eventGuid: self.guid)
    }
}
