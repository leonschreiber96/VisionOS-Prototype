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
    var isCaptureMove: Bool = false
    
    init(from origin: ChessBoardField, to target: ChessBoardField, which piece: (type: PieceType, color: PieceColor), isCapture: Bool = false) {
        self.origin = origin
        self.target = target
        self.movedPiece = piece
        
        self.isCastlingMove = self.determineIfCastlingMove()
        self.isPromotionMove = self.determineIfPromotionMove()
        self.isEnPassantMove = self.determineIfEnPassantMove()
        self.isCaptureMove = isCapture
    }
    
    public func getAlgebraicNotation() -> String {
        if (self.isCastlingMove && self.target.file == 2) { return "O-O-O" }
        if (self.isCastlingMove && self.target.file == 6) { return "O-O" }
        
        var notation: String = ""
        
        if (self.movedPiece.type == .knight) { notation += "♞" }
        else if (self.movedPiece.type == .bishop) { notation += "♝" }
        else if (self.movedPiece.type == .rook) { notation += "♜" }
        else if (self.movedPiece.type == .queen) { notation += "♛" }
        else if (self.movedPiece.type == .king) { notation += "♚" }
        
        if (self.isCaptureMove) {
            if (self.movedPiece.type == .pawn) { notation += String("abcdefgh"["abcdefgh".index("abcdefgh".startIndex, offsetBy: self.origin.file)]) }
            notation += "x"
        }
        
        notation += self.target.rawValue.lowercased()
        
        if (self.isEnPassantMove) { notation += "e.p." }
        
        return notation
    }

    
    private func determineIfCastlingMove() -> Bool { self.movedPiece.type == PieceType.king && abs(self.origin.index - self.target.index) == 2 }
    private func determineIfPromotionMove() -> Bool { self.movedPiece.type == PieceType.pawn && self.target.file == (self.movedPiece.color == .white ? 7 : 0)}
    private func determineIfEnPassantMove() -> Bool { self.movedPiece.type == PieceType.pawn && abs(self.target.file - self.origin.file) == 2 }
}
