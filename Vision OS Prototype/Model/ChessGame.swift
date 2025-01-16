//
//  ChessGame.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 15.01.25.
//

class ChessGame {
    public var board: ChessBoard
    
    init() {
        self.board = ChessBoard()
    }
}

class ChessBoard {
    // Chess board is internally represented as 64 integers (1 per field)
    // Each integer is 4 bit → MSB signifies white/black, others indicate piece type
    // Empty field: 000, Pawn: 001, Rook: 010, Knight: 011, Bishop: 100, King: 101, Queen: 110
    // Indexing starts at field a1 and ends at h8
    private var board: [Int]
    
    init() {
        // Create an 8x8 board with all fields initialized to 0b000 (empty)
        board = Array(repeating: 0b000, count: 64)
        
        // Set up White pieces (row 1: a1 to h1)
        board[0] = 0b1010 // a1 → White Rook
        board[1] = 0b1011 // b1 → White Knight
        board[2] = 0b1100 // c1 → White Bishop
        board[3] = 0b1110 // d1 → White Queen
        board[4] = 0b1101 // e1 → White King
        board[5] = 0b1100 // f1 → White Bishop
        board[6] = 0b1011 // g1 → White Knight
        board[7] = 0b1010 // h1 → White Rook
        
        // Set up White pawns (row 2: a2 to h2)
        for i in 8...15 {
            board[i] = 0b1001 // White Pawn
        }
        
        // Set up Black pawns (row 7: a7 to h7)
        for i in 48...55 {
            board[i] = 0b0001 // Black Pawn
        }
        
        // Set up Black pieces (row 8: a8 to h8)
        board[56] = 0b0010 // a8 → Black Rook
        board[57] = 0b0011 // b8 → Black Knight
        board[58] = 0b0100 // c8 → Black Bishop
        board[59] = 0b0110 // d8 → Black Queen
        board[60] = 0b0101 // e8 → Black King
        board[61] = 0b0100 // f8 → Black Bishop
        board[62] = 0b0011 // g8 → Black Knight
        board[63] = 0b0010 // h8 → Black Rook
    }
    
    public func getPiece(at field: String) -> Int {
        // Get the internal index corresponding to the field name
        let index = getInternalIndex(for: field)
        
        // Access the piece stored at the index
        return board[index]  // Assuming `board` is an array of 64 integers representing the chessboard
    }
    
    private func getFieldName(for index: Int) -> String {
        if index < 0 || index >= 64 { fatalError("Invalid index: \(index)") }
        
        let col = index % 8                          // Column index (0 to 7)
        let row = index / 8                          // Row index (0 to 7)
        
        let colChar = "abcdefgh".dropFirst(col).first!  // Get the corresponding column letter
        let rowChar = String(row + 1)                   // Convert the row index to a 1-based row number
        
        return "\(colChar)\(rowChar)"                // Concatenate column letter and row number
    }
    
    public func getInternalIndex(for field: String) -> Int {
        // if (!ChessBoard.fieldStringIsValid(field)) { throw ChessError.invalidBoardIndex }
        
        let colIndex = "abcdefgh".firstIndex(of: field.first!)!
        let col = "abcdefgh".distance(from: "abcdefgh".startIndex, to: colIndex)
        let row = Int(field.last!.asciiValue! - 49)
        
        return col + row * 8
    }
    
    private static func fieldStringIsValid(_ field: String) -> Bool {
        field.count == 2 && 
            field.first!.isLetter &&
            field.last!.isNumber &&
            field.first!.lowercased() >= "a" &&
            field.first!.lowercased() <= "h" &&
            field.last!.lowercased() >= "1" &&
            field.last!.lowercased() <= "8"
    }
}



