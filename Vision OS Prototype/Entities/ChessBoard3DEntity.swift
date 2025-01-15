//
//  ChessBoardEntity.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//

import RealityKit
import SwiftUI
import RealityKitContent

class ChessBoardEntity : Entity {
    // MARK: - Internal State
    let boardState: BoardState = .init(fen: "rnbqkbnr/ppppp1pp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    @MainActor required init () {
        super.init()
    }
    
    init(testBool: Bool) async {
        super.init()
        
        guard let chessBoard = await RealityKitContent.entity(named: "ChessBoard") else {
            fatalError("Could not load chess board asset.")
        }
        
        self.addChild(chessBoard)
        
        update(scale: SIMD3(repeating: 0.04), position: .zero)
        
        boardState.displayBoard()
    }
    
    // MARK: - Updates

    /// Updates all the entity's configurable elements.
    ///
    /// - Parameters:
    ///   - configuration: Information about how to configure the Earth.
    ///   - satelliteConfiguration: An array of configuration structures, one
    ///     for each artificial satellite.
    ///   - moonConfiguration: A satellite configuration structure that's
    ///     specifically for the Moon.
    ///   - animateUpdates: A Boolean that indicates whether changes to certain
    ///     configuration values should be animated.
    func update(scale: SIMD3<Float>, position: SIMD3<Float>) {

        // Scale and position the entire entity.
        move(
            to: Transform(
                scale: scale,
//                rotation: .init(angle: 0.2, axis: [0, 1, 0]),
                translation: position
            ),
            relativeTo: parent)
    }
    
    func chessPieceToEntity(piece: ChessPiece) -> String {
        return "Cylinder_043_0"
        if (piece.color == "b") {
            
        }
    }
    
    func chessPieceToEntityName(piece: String) -> String {
        if (piece == "A8") { return "Cylinder_043_0" }
        else if (piece == "B8") { return "Cylinder_042_1" }
        else if (piece == "C8") { return "Cylinder_041_2" }
        else if (piece == "A7") { return "Cylinder_040_3" }
        else if (piece == "B7") { return "Cylinder_039_4" }
        else if (piece == "C7") { return "Cylinder_038_5" }
        else if (piece == "D7") { return "Cylinder_037_6" }
        else if (piece == "E7") { return "Cylinder_036_7" }
        else if (piece == "F7") { return "Cylinder_035_8" }
        else if (piece == "G7") { return "Cylinder_034_9" }
        else if (piece == "A2") { return "Cylinder_033_10" }
        else if (piece == "B2") { return "Cylinder_032_11" }
        else if (piece == "C2") { return "Cylinder_031_12" }
        else if (piece == "D2") { return "Cylinder_030_13" }
        else if (piece == "E2") { return "Cylinder_029_14" }
        else if (piece == "F2") { return "Cylinder_028_15" }
        else if (piece == "G2") { return "Cylinder_027_16" }
        else if (piece == "A1") { return "Cylinder_026_17" }
        else if (piece == "B1") { return "Cylinder_025_18" }
        else if (piece == "C1") { return "Cylinder_024_19" }
        else if (piece == "G1") { return "Cylinder_011_20" }
        else if (piece == "F1") { return "Cylinder_010_21" }
        else if (piece == "D1") { return "Cylinder_009_22" }
        else if (piece == "E1") { return "Cylinder_008_23" }
        else if (piece == "H1") { return "Cylinder_007_24" }
        else if (piece == "H2") { return "Cylinder_006_25" }
        else if (piece == "G8") { return "Cylinder_005_26" }
        else if (piece == "F8") { return "Cylinder_004_27" }
        else if (piece == "D8") { return "Cylinder_003_28" }
        else if (piece == "E8") { return "Cylinder_002_29" }
        else if (piece == "H8") { return "Cylinder_001_30" }
        else if (piece == "H7") { return "Cylinder_31" }
        else { return "" }
    }
}

import Foundation

struct ChessMove {
    let from: String // e.g., "e2"
    let to: String   // e.g., "e4"
}

class BoardState {
    private var board: [String: ChessPiece] = [:]
    private var currentTurn: String = "w"
    
    init(fen: String) {
        parseFEN(fen: fen)
    }
    
    func piece(at position: String) -> ChessPiece? {
        return board[position]
    }
    
    func makeMove(_ move: ChessMove, color: String) -> Bool {
        guard currentTurn == color else {
            print("It's not \(color)'s turn!")
            return false
        }
        
        guard let piece = board[move.from] else {
            print("No piece at \(move.from)")
            return false
        }
        
        guard piece.color == color else {
            print("The piece at \(move.from) does not belong to \(color)")
            return false
        }
        
        // Assume all moves are valid for simplicity (you can add validation)
        board[move.to] = piece
        board[move.from] = nil
        currentTurn = color == "w" ? "b" : "w"
        return true
    }
    
    func displayBoard() {
        let ranks = (1...8).reversed()
        let files = "abcdefgh"
        for rank in ranks {
            var line = ""
            for file in files {
                let position = "\(file)\(rank)"
                if let piece = board[position] {
                    line += piece.color == "w" ? piece.type.uppercased() : piece.type.lowercased()
                } else {
                    line += "."
                }
                line += " "
            }
            print(line)
        }
    }
    
    private func parseFEN(fen: String) {
        let parts = fen.split(separator: " ")
        guard parts.count >= 2 else {
            fatalError("Invalid FEN string")
        }
        
        let piecePlacement = parts[0]
        let activeColor = parts[1]
        
        board = [:]
        currentTurn = activeColor == "w" ? "w" : "b"
        
        let ranks = piecePlacement.split(separator: "/")
        guard ranks.count == 8 else {
            fatalError("Invalid FEN string")
        }
        
        for (rankIndex, rank) in ranks.enumerated() {
            let rankNumber = 8 - rankIndex
            var fileIndex = 0
            
            for char in rank {
                if let emptySquares = char.wholeNumberValue {
                    fileIndex += emptySquares
                } else {
                    // Use String.Index to subscript a string
                    let file = "abcdefgh".index("abcdefgh".startIndex, offsetBy: fileIndex)
                    let position = "\(String("abcdefgh"[file]))\(rankNumber)"
                    let color: String = char.isUppercase ? "w" : "b"
                    let pieceType = char.uppercased()
                    board[position] = ChessPiece(type: pieceType, color: color)
                    fileIndex += 1
                }
            }
        }
    }
}
