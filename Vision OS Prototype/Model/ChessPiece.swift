//
//  ChessPiece.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//

import Foundation

// Repräsentiert eine Schachfigur
struct ChessPiece {
    let type: String  // Der Typ der Figur, z. B. "♔" für König
    let color: String // Die Farbe der Figur, "white" oder "black"
}

// Repräsentiert das Schachbrett und die Figuren
class ChessBoardOld: ObservableObject {
    @Published var board: [[ChessPiece?]] // 8x8 Array, das Figuren enthält

    init() {
        // Initialisiere ein leeres Schachbrett
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        setupInitialPosition() // Fülle die Anfangspositionen
    }

    // Setzt die Standardpositionen der Schachfiguren
    func setupInitialPosition() {
        // Schwarze Figuren (untere Reihen)
        board[0] = [
            ChessPiece(type: "♜", color: "white"),
            ChessPiece(type: "♞", color: "white"),
            ChessPiece(type: "♝", color: "white"),
            ChessPiece(type: "♚", color: "white"), 
            ChessPiece(type: "♛", color: "white"),
            ChessPiece(type: "♝", color: "white"),
            ChessPiece(type: "♞", color: "white"),
            ChessPiece(type: "♜", color: "white")
        ]
        board[1] = Array(repeating: ChessPiece(type: "♙", color: "white"), count: 8)

        // Weiße Figuren (obere Reihen)
        board[7] = [
            ChessPiece(type: "♜", color: "black"),
            ChessPiece(type: "♞", color: "black"),
            ChessPiece(type: "♝", color: "black"),
            ChessPiece(type: "♛", color: "black"), // Schwarze Dame (auf dunklem Feld)
            ChessPiece(type: "♚", color: "black"), // Schwarzer König (auf hellem Feld)
            ChessPiece(type: "♝", color: "black"),
            ChessPiece(type: "♞", color: "black"),
            ChessPiece(type: "♜", color: "black")
        ]
        board[6] = Array(repeating: ChessPiece(type: "♙", color: "black"), count: 8)
    }
    
    // Aktualisiert das Schachbrett basierend auf einem Zug in algebraischer Notation
    func updateBoard(move: String) {
        // Beispiel: "e2e4"
        guard move.count == 4 else { return }

        let cols = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7]
        let fromCol = cols[String(move.prefix(1))] ?? -1
        let fromRow = 8 - Int(String(move[move.index(move.startIndex, offsetBy: 1)]))!
        let toCol = cols[String(move[move.index(move.startIndex, offsetBy: 2)])] ?? -1
        let toRow = 8 - Int(String(move[move.index(move.startIndex, offsetBy: 3)]))!

        // Stelle sicher, dass die Koordinaten gültig sind
        guard (0..<8).contains(fromCol), (0..<8).contains(fromRow),
              (0..<8).contains(toCol), (0..<8).contains(toRow) else { return }

        // Bewege die Figur
        board[toRow][toCol] = board[fromRow][fromCol]
        board[fromRow][fromCol] = nil

        // Benachrichtige alle Views, dass sich etwas geändert hat
        objectWillChange.send()
    }
}
