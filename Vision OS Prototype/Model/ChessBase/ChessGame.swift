//
//  ChessGame.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 15.01.25.
//
import Foundation

class ChessGame {
    public private(set) var board: ChessBoard
    
    public private(set) var colorOnTurn: PieceColor = .white
    public private(set) var isGameOver: Bool = false
    public private(set) var result: ChessGameResult?
    public private(set) var moveHistory: [ChessMove] = []
    // public var castlingRights: CastlingRights = .all
    // public var enPassantTarget: ChessBoardField?
    
    init() {
        self.board = ChessBoard()
    }
    
    public func addMove(from origin: ChessBoardField, to target: ChessBoardField) {
        guard let piece = self.board.getPiece(at: origin) else {
            print("Move could not be added, because no piece is on \(origin)")
            return
        }
        
        let move = ChessMove(from: origin, to: target, which: piece)
        self.moveHistory.append(move)
        self.board.movePiece(from: origin, to: target)
        
        if (move.isCastlingMove) {
            let possibleRookOrigins: [ChessBoardField] = move.movedPiece.color == .white ? [.A1, .H1] : [.A8, .H8]
            let possibleRookDestinations: [ChessBoardField] = move.movedPiece.color == .white ? [.C1, .G1] : [.C8, .G8]
            let correspondingRookOrigin = move.target.file > 4 ? possibleRookOrigins[1] : possibleRookOrigins[0]
            let correspondingRookTarget = move.target.file > 4 ? possibleRookDestinations[1] : possibleRookDestinations[0]
            
            self.board.movePiece(from: correspondingRookOrigin, to: correspondingRookTarget)
        }
        
        if (move.isEnPassantMove) {
            let targetIndex = move.movedPiece.color == .white ? move.target.index - 8 : move.target.index + 8
            let targetField = ChessBoardField(index: targetIndex)!
            
            self.board.removePiece(from: targetField)
        }
        
        if (move.isPromotionMove) {
            self.board.setPiece(on: move.target, type: .queen, color: move.movedPiece.color) // For simplicity, we assume everyone always want to get a queen when promoting :)
        }
    }
    
    public func declareWinner(color: PieceColor) {
        self.isGameOver = true
        self.result = .checkmate(for: color)
    }
    
    public func declareDraw() {
        self.isGameOver = true
        self.result = .draw
    }
    
    public func setColorOnTurn(color: PieceColor) { self.colorOnTurn = color }
    public func toggleColorOnTurn() { self.colorOnTurn = self.colorOnTurn == .white ? .black : .white }
}
