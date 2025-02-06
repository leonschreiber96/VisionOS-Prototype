//
//  ChessBoard2DViewModel.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation
import SwiftUICore

class ChessBoard2DViewModel: ObservableObject {
    @Published private(set) var pieces: [(type: PieceType, color: PieceColor, position: ChessBoardField)] = []
    @Published private(set) var highlightFields: [ChessBoardField] = []
    
    private var streamObject: ChessEventStream
    
    init(from chessStream: ChessEventStream) {
        self.streamObject = chessStream
        let moves = self.streamObject.movesUntilCurrentTimestamp
        let tempBoard = ChessBoard()
        for move in moves {
            tempBoard.movePiece(from: move.origin, to: move.target)
        }
        self.pieces = tempBoard.getAllPieces()
        
        GameStateChangedNotificationCenter.shared.registerMoveHandler(eventGuid: chessStream.eventObject.guid, observer: {move in
            self.update(highlight: [move.origin, move.target])
        })
        
        guard let lastMove = moves.last
        else { return }
        
        self.highlightFields = [
            lastMove.origin,
            lastMove.target
        ]
    }
    
    public func update(highlight highlightedFields: [ChessBoardField] = []) {
        let moves = self.streamObject.movesUntilCurrentTimestamp
        
        let tempGame = ChessGame()
        for move in moves {
            tempGame.addMove(from: move.origin, to: move.target)
        }
        
        self.pieces = tempGame.board.getAllPieces()
        self.highlightFields = highlightedFields
    }
}
