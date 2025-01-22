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
    public private(set) var clocks: (white: Clock, black: Clock)
    
    init(gameTime: Int) {
        self.board = ChessBoard()
        self.clocks = (.init(startingSeconds: gameTime), .init(startingSeconds: gameTime))
    }
    
    public func addMove(from origin: ChessBoardField, to target: ChessBoardField) {
        guard let piece = self.board.getPiece(at: origin) else {
            return
        }
        
        let move = ChessMove(from: origin, to: target, which: piece)
        self.moveHistory.append(move)
        self.board.movePiece(from: origin, to: target)
    }
    
    public func setColorOnTurn(color: PieceColor) { self.colorOnTurn = color }
    public func toggleColorOnTurn() { self.colorOnTurn = self.colorOnTurn == .white ? .black : .white }
}
