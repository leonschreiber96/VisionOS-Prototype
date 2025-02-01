//
//  ChessEventViewModel.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

class ChessEventViewModel: ObservableObject {
    public let eventObject: ChessEvent
    
    @Published public var remainingTimeWhite: String
    @Published public var remainingTimeBlack: String
    
    @Published public var whiteMoves: [String]
    @Published public var blackMoves: [String]
    
    public init(event: ChessEvent) {
        self.eventObject = event
        
        let clocks = event.clocks
        self.remainingTimeWhite = String(format: "%02d:%02d", clocks.white.secondsRemaining / 60, clocks.white.secondsRemaining % 60)
        self.remainingTimeBlack = String(format: "%02d:%02d", clocks.black.secondsRemaining / 60, clocks.black.secondsRemaining % 60)
        
        self.whiteMoves = event.game.moveHistory.filter{ $0.movedPiece.color == .white }.map { return $0.getAlgebraicNotation() }
        self.blackMoves = event.game.moveHistory.filter{ $0.movedPiece.color == .black }.map { return $0.getAlgebraicNotation() }
        
        GameStateChangedNotificationCenter.shared.registerMoveHandler(eventGuid: self.eventObject.guid) { [weak self] move in
            if (move.movedPiece.color == .white) { self?.whiteMoves.append(move.getAlgebraicNotation()) }
            else { self?.blackMoves.append(move.getAlgebraicNotation()) }
        }
    }
}
