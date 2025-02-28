//
//  ChessBoard.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import Foundation

/**
 Represents a chessboard and its current state.
 
 The board is internally stored as an array of 64 integers, where each integer represents a piece
 using a compact 4-bit encoding:
 
 - **MSB (Most Significant Bit):** 1 for Black, 0 for White
 - **Lower 3 Bits:** Piece type:
   - `000` (0) → Empty
   - `001` (1) → Pawn
   - `010` (2) → Rook
   - `011` (3) → Knight
   - `100` (4) → Bishop
   - `101` (5) → King
   - `110` (6) → Queen
 
 Board indexing starts at `a1` (index 0) and ends at `h8` (index 63).
 */
class ChessBoard {
    /// Internal representation of the chessboard (64 squares, each storing a 4-bit encoded piece).
    private var board: [Int] = Array(repeating: 0b000, count: 64)
    
    /// Initializes an empty chessboard and sets up the starting position.
    init() {
        self.setupPieces()
    }
    
    /**
     Retrieves the piece at a given board position.
     
     - Parameter field: The board position to check.
     - Returns: A tuple containing the piece type and color, or `nil` if the square is empty.
     */
    public func getPiece(at field: ChessBoardField) -> (type: PieceType, color: PieceColor)? {
        let fieldValue: Int = board[field.index]
        
        if fieldValue == 0b000 { return nil } // Empty square
        
        let typeValue: Int = fieldValue & 0b0111  // Extract piece type
        let colorValue: Int = fieldValue & 0b1000 // Extract piece color
        
        // Validate the extracted values
        guard let type = PieceType(rawValue: typeValue), let color = PieceColor(rawValue: colorValue) else {
            print("Error: Invalid piece type or color value found in chess board: \(String(fieldValue, radix: 2))")
            return nil
        }
        
        return (type, color)
    }
    
    /**
     Retrieves all pieces currently on the board.
     
     - Returns: An array of tuples containing the piece type, color, and position.
     */
    public func getAllPieces() -> [(type: PieceType, color: PieceColor, position: ChessBoardField)] {
        var pieces: [(type: PieceType, color: PieceColor, position: ChessBoardField)] = []
            
        for index in 0..<64 {
            let fieldValue = board[index]
            
            if fieldValue == 0b000 { continue } // Skip empty squares
            
            let typeValue = fieldValue & 0b0111
            let colorValue = fieldValue & 0b1000
            
            guard let type = PieceType(rawValue: typeValue), let color = PieceColor(rawValue: colorValue) else {
                print("Error: Invalid piece type or color at index \(index) with value \(String(fieldValue, radix: 2))")
                continue
            }
            
            let position = ChessBoardField(index: index)!
            pieces.append((type, color, position))
        }
        
        return pieces
    }
    
    /**
     Moves a piece from one square to another.
     
     - Note: This method does not check move legality.
     - Parameters:
        - from: The starting position of the piece.
        - to: The destination position.
     */
    public func movePiece(from: ChessBoardField, to: ChessBoardField) {
        board[to.index] = board[from.index]  // Move the piece
        board[from.index] = 0b000            // Clear the original position
    }
    
    /**
     Places a specific piece on a given square.
     
     - Parameters:
        - on: The board position where the piece should be placed.
        - type: The type of the piece.
        - color: The color of the piece.
     */
    public func setPiece(on: ChessBoardField, type: PieceType, color: PieceColor) {
        board[on.index] = color.rawValue | type.rawValue
    }
    
    /**
     Removes a piece from a given square.
     
     - Parameter from: The position of the piece to remove.
     */
    public func removePiece(from: ChessBoardField) {
        board[from.index] = 0b000
    }
    
    /// Sets up the chessboard with the standard starting position.
    private func setupPieces() {
        // White major pieces (1st row: a1 to h1)
        board[0] = PieceColor.white.rawValue | PieceType.rook.rawValue
        board[1] = PieceColor.white.rawValue | PieceType.knight.rawValue
        board[2] = PieceColor.white.rawValue | PieceType.bishop.rawValue
        board[3] = PieceColor.white.rawValue | PieceType.queen.rawValue
        board[4] = PieceColor.white.rawValue | PieceType.king.rawValue
        board[5] = PieceColor.white.rawValue | PieceType.bishop.rawValue
        board[6] = PieceColor.white.rawValue | PieceType.knight.rawValue
        board[7] = PieceColor.white.rawValue | PieceType.rook.rawValue
        
        // White pawns (2nd row: a2 to h2)
        for i in 8...15 { board[i] = PieceColor.white.rawValue | PieceType.pawn.rawValue }
        
        // Black pawns (7th row: a7 to h7)
        for i in 48...55 { board[i] = PieceColor.black.rawValue | PieceType.pawn.rawValue }
        
        // Black major pieces (8th row: a8 to h8)
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
