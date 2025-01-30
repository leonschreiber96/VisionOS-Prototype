//
//  ChessPiece.swift
//  Vision OS Prototype
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
class ChessBoard: ObservableObject {
    @Published var board: [[ChessPiece?]] // 8x8 Array, das Figuren enthält

    init() {
        // Initialisiere ein leeres Schachbrett
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        setupInitialPosition() // Fülle die Anfangspositionen
    }

    // Setzt die Standardpositionen der Schachfiguren
    func setupInitialPosition() {
        // Weiße Figuren (untere Reihe)
        board[0] = [
            ChessPiece(type: "♜", color: "black"),
            ChessPiece(type: "♞", color: "black"),
            ChessPiece(type: "♝", color: "black"),
            ChessPiece(type: "♛", color: "black"),
            ChessPiece(type: "♚", color: "black"),
            nil, //leer
            nil, //leer
            ChessPiece(type: "♜", color: "black")
        ]

        // Weiße Bauern (siebte Reihe)
        board[1] = [
            ChessPiece(type: "♙", color: "black"),
            ChessPiece(type: "♙", color: "black"),
            ChessPiece(type: "♙", color: "black"),
            ChessPiece(type: "♙", color: "black"),
            nil, // leer
            ChessPiece(type: "♙", color: "black"),
            ChessPiece(type: "♙", color: "black"),
            ChessPiece(type: "♙", color: "black")
        ]

        // Leere Felder und spezifische Positionen der weißen Figuren
        board[2] = Array(repeating: nil, count: 8)
        board[2][5] = ChessPiece(type: "♞", color: "black") // Weißer Springer

        board[3] = Array(repeating: nil, count: 8)
        board[3][4] = ChessPiece(type: "♙", color: "black") // Weißer Bauer
        board[3][2] = ChessPiece(type: "♝", color: "black") // Weißer Läufer

        board[4] = Array(repeating: nil, count: 8)
        board[4][4] = ChessPiece(type: "♙", color: "white") // Schwarzer Bauer

        board[5] = Array(repeating: nil, count: 8)
        board[5][2] = ChessPiece(type: "♞", color: "white") // Schwarzer Springer

        // Schwarze Bauern (zweite Reihe,)
        board[6] = [
            ChessPiece(type: "♙", color: "white"),
            ChessPiece(type: "♙", color: "white"),
            ChessPiece(type: "♙", color: "white"),
            ChessPiece(type: "♙", color: "white"),
            nil, //leer
            ChessPiece(type: "♙", color: "white"),
            ChessPiece(type: "♙", color: "white"),
            ChessPiece(type: "♙", color: "white")
        ]

        // Schwarze Figuren (obere Reihe)
        board[7] = [
            ChessPiece(type: "♜", color: "white"),
            nil, //leer
            ChessPiece(type: "♝", color: "white"),
            ChessPiece(type: "♛", color: "white"),
            ChessPiece(type: "♚", color: "white"),
            ChessPiece(type: "♝", color: "white"),
            ChessPiece(type: "♞", color: "white"),
            ChessPiece(type: "♜", color: "white")
        ]
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

