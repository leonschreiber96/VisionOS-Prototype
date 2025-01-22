//
//  ChessMove.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//


import Foundation

class ChessMove {
    var origin: ChessBoardField
    var target: ChessBoardField
    var movedPiece: (type: PieceType, color: PieceColor)
    var isCastlingMove: Bool = false
    var isPromotionMove: Bool = false
    var isEnPassantMove: Bool = false
    
    init(from origin: ChessBoardField, to target: ChessBoardField, which piece: (type: PieceType, color: PieceColor)) {
        self.origin = origin
        self.target = target
        self.movedPiece = piece
        
        self.isCastlingMove = self.determineIfCastlingMove()
        self.isPromotionMove = self.determineIfPromotionMove()
        self.isEnPassantMove = self.determineIfEnPassantMove()
    }
    
    private func determineIfCastlingMove() -> Bool { self.movedPiece.type == PieceType.king && abs(self.origin.index - self.target.index) == 2 }
    private func determineIfPromotionMove() -> Bool { self.movedPiece.type == PieceType.pawn && self.target.file == (self.movedPiece.color == .white ? 7 : 0)}
    private func determineIfEnPassantMove() -> Bool { self.movedPiece.type == PieceType.pawn && abs(self.target.file - self.origin.file) == 2 }
}
