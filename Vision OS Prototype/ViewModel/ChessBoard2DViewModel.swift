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
    
    public func update(highlightFields: [ChessBoardField] = []) {
        self.pieces = self.boardObject.getAllPieces()
        self.highlightFields = highlightFields
    }
}
