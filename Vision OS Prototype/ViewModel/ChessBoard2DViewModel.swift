//
//  ChessBoard2DViewModel.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

class ChessBoard2DViewModel: ObservableObject {
    public let boardObject: ChessBoard
    
    @Published public var pieces: [(type: PieceType, color: PieceColor, position: ChessBoardField)]
    @Published public var highlightFields: [ChessBoardField] = []
    
    init(boardState: ChessBoard) {
        self.boardObject = boardState
        self.pieces = boardState.getAllPieces()
    }
    
    public static func createInstance(from chessEvent: ChessEvent) -> ChessBoard2DViewModel {
        let chessBoard2DViewModel = ChessBoard2DViewModel(boardState: chessEvent.game.board)
        if (chessEvent.game.moveHistory.last != nil) {
            chessBoard2DViewModel.highlightFields = [
                chessEvent.game.moveHistory.last!.origin,
                chessEvent.game.moveHistory.last!.target
            ]
        }
        
        GameStateChangedNotificationCenter.shared.registerMoveHandler(eventGuid: chessEvent.guid, observer: {_ in
            chessBoard2DViewModel.update()
        })
        
        return chessBoard2DViewModel
    }
    
    public func update(highlightFields: [ChessBoardField] = []) {
        self.pieces = self.boardObject.getAllPieces()
        self.highlightFields = highlightFields
    }
}
