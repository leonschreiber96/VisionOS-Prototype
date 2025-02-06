//
//  ChessEventViewModel.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

class ChessEventStreamViewModel: ObservableObject {
    public let streamObject: ChessEventStream
    
    @Published var remainingTimeWhite: String
    @Published var remainingTimeBlack: String
    
    @Published var whiteMoves: [String]
    @Published var blackMoves: [String]
    
    @Published var movesUntilCurrentTimestamp: [ChessMove]
    @Published var whiteMovesUntilCurrentTimestamp: [ChessMove]
    @Published var blackMovesUntilCurrentTimestamp: [ChessMove]
    
    public init(stream: ChessEventStream) {
        self.streamObject = stream
        
        let clocks = stream.eventObject.clocks
        self.remainingTimeWhite = String(format: "%02d:%02d", clocks.white.secondsRemaining / 60, clocks.white.secondsRemaining % 60)
        self.remainingTimeBlack = String(format: "%02d:%02d", clocks.black.secondsRemaining / 60, clocks.black.secondsRemaining % 60)
        
        self.whiteMoves = stream.eventObject.game.moveHistory.filter{ $0.movedPiece.color == .white }.map { return $0.getAlgebraicNotation() }
        self.blackMoves = stream.eventObject.game.moveHistory.filter{ $0.movedPiece.color == .black }.map { return $0.getAlgebraicNotation() }
        
        self.movesUntilCurrentTimestamp = stream.movesUntilCurrentTimestamp
        self.whiteMovesUntilCurrentTimestamp = stream.movesUntilCurrentTimestamp.filter { $0.movedPiece.color == .white }
        self.blackMovesUntilCurrentTimestamp = stream.movesUntilCurrentTimestamp.filter { $0.movedPiece.color == .black }
    }
}
