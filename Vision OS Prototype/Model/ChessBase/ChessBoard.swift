//
//  ChessBoard.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import Foundation

class ChessBoard {
    // Chess board is internally represented as 64 integers (1 per field)
    // Each integer is 4 bit → MSB signifies white/black, others indicate piece type
    // Empty field: 000, Pawn: 001, Rook: 010, Knight: 011, Bishop: 100, King: 101, Queen: 110
    // Indexing starts at field a1 and ends at h8
    private var board: [Int] = Array(repeating: 0b000, count: 64)
    
    init() {
        self.setupPieces()
    }
    
    public func getPiece(at field: ChessBoardField) -> (type: PieceType, color: PieceColor)? {
        // Access the piece stored at the index
        let fieldValue: Int = board[field.index]
        
        if (fieldValue == 0b000) { return nil }
        
        let typeValue: Int = fieldValue & 0b0111
        let colorValue: Int = fieldValue & 0b1000
        
        guard let type = PieceType(rawValue: typeValue), let color = PieceColor(rawValue: colorValue) else {
            print("Error: Invalid piece type or color value found in chess board: \(String(fieldValue, radix: 2))")
            return nil
        }
        
        return (type, color)
    }
    
    public func getAllPieces() -> [(type: PieceType, color: PieceColor, position: ChessBoardField)] {
        var pieces: [(type: PieceType, color: PieceColor, position: ChessBoardField)] = []
            
        for index in 0...63 {
            let fieldValue = board[index]
            
            if fieldValue == 0b000 { continue }
            
            let typeValue = fieldValue & 0b0111
            let colorValue = fieldValue & 0b1000
            
            guard let type = PieceType(rawValue: typeValue), let color = PieceColor(rawValue: colorValue) else {
                print("Error: Invalid piece type or color value found at index \(index) with value \(String(fieldValue, radix: 2))")
                continue
            }
            
            let position = ChessBoardField(index: index)!
            
            pieces.append((type, color, position))
        }
        
        return pieces
    }
    
    public func movePiece(from: ChessBoardField, to: ChessBoardField) {
        board[to.index] = board[from.index]
        board[from.index] = 0b000
    }
    
    public func setPiece(on: ChessBoardField, type: PieceType, color: PieceColor) {
        board[on.index] = color.rawValue | type.rawValue
    }
    
    public func removePiece(from: ChessBoardField) {
        board[from.index] = 0b000
    }
    
    private func setupPieces() {
        // Set up White pieces (row 1: a1 to h1)
        board[0] = PieceColor.white.rawValue | PieceType.rook.rawValue
        board[1] = PieceColor.white.rawValue | PieceType.knight.rawValue
        board[2] = PieceColor.white.rawValue | PieceType.bishop.rawValue
        board[3] = PieceColor.white.rawValue | PieceType.queen.rawValue
        board[4] = PieceColor.white.rawValue | PieceType.king.rawValue
        board[5] = PieceColor.white.rawValue | PieceType.bishop.rawValue
        board[6] = PieceColor.white.rawValue | PieceType.knight.rawValue
        board[7] = PieceColor.white.rawValue | PieceType.rook.rawValue
        
        // Set up White pawns (row 2: a2 to h2)
        for i in 8...15 { board[i] = PieceColor.white.rawValue | PieceType.pawn.rawValue }
        
        // Set up Black pawns (row 7: a7 to h7)
        for i in 48...55 { board[i] = PieceColor.black.rawValue | PieceType.pawn.rawValue }
        
        // Set up Black pieces (row 8: a8 to h8)
        board[56] = PieceColor.black.rawValue | PieceType.rook.rawValue
        board[57] = PieceColor.black.rawValue | PieceType.knight.rawValue
        board[58] = PieceColor.black.rawValue | PieceType.bishop.rawValue
        board[59] = PieceColor.black.rawValue | PieceType.queen.rawValue
        board[60] = PieceColor.black.rawValue | PieceType.king.rawValue
        board[61] = PieceColor.black.rawValue | PieceType.bishop.rawValue
        board[62] = PieceColor.black.rawValue | PieceType.knight.rawValue
        board[63] = PieceColor.black.rawValue | PieceType.rook.rawValue
    }
}
