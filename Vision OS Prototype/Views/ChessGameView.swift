//
//  ChessGameView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//

import SwiftUI

struct ChessGameView: View {
    @StateObject var chessBoard = ChessBoard()

    @State private var leftPlayerMoves = [String]() // Liste der Züge von Spieler 1
    @State private var rightPlayerMoves = [String]() // Liste der Züge von Spieler 2
    @State private var leftPlayerSeconds = 330
    @State private var rightPlayerSeconds = 285
    @State private var isPlayer1Turn = true // Gibt an, welcher Spieler am Zug ist

    @State private var isPaused = true // Timer startet pausiert
    @State private var currentDelay: Double = 0.0 // Aktuelle Verzögerung für Züge
    @State private var hasStarted = false // Gibt an, ob das Spiel gestartet wurde

    // Vollständige Zugliste mit Verzögerungen
    let movesWithDelays: [(String, Double)] = [
            ("f1c4", 5.0),
            ("d7d6", 5.0),
            ("g1f3", 5.0),
            ("b8c6", 5.0),
            ("a2a3", 5.0),
            ("a7a5", 5.0),
            ("d2d3", 5.0),
            ("0-0", 5.0), // Kurze Rochade
            ("h2h3", 5.0),
            ("c8e6", 5.0),
            ("c1e3", 5.0),
            ("a5a4", 5.0),
            ("c4b5", 5.0),
            ("c6d4", 5.0),
            ("b5a4", 5.0),
            ("c7c6", 5.0),
            ("a4b3", 5.0),
            ("d4b3", 5.0),
            ("c2b3", 5.0),
            ("c5e3", 5.0),
            ("f2e3", 5.0),
            ("d8b6", 5.0) // Letzter Zug ohne zusätzliche Verzögerung
        ]

    @State private var timer: Timer? = nil // Timer-Referenz

    var body: some View {
        VStack(spacing: 10) {
            // Anzeige des aktuellen Spielers
            CurrentPlayerView(
                playerName: isPlayer1Turn ? "Anton Mustermann" : "Magnus Carlsen",
                remainingTime: isPlayer1Turn ? timeString(from: leftPlayerSeconds) : timeString(from: rightPlayerSeconds)
            )

            // HStack: Zuglisten + Schachbrett
            HStack(spacing: 50) {
                PlayerMovesView(
                    playerName: "Anton Mustermann",
                    moves: leftPlayerMoves,
                    remainingTime: timeString(from: leftPlayerSeconds)
                )
                .frame(width: 120)

                ChessBoardView(chessBoard: chessBoard)

                PlayerMovesView(
                    playerName: "Magnus Carlsen",
                    moves: rightPlayerMoves,
                    remainingTime: timeString(from: rightPlayerSeconds)
                )
                .frame(width: 120)
            }

            HStack {
                // Button für Zugausführung
                Button(action: {
                    startGame()
                }) {
                    Text("Livestream starten")
                        .padding()
                        .background(hasStarted ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(hasStarted) // Button deaktivieren, nachdem das Spiel gestartet wurde
                }

                // Pause/Weiter-Button
                Button(action: {
                    togglePause()
                }) {
                    Text(isPaused ? "Weiter" : "Pause")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            // PlayerInfoView unterhalb des Schachbretts
            PlayerInfoView(
                player1: Player(name: "Anton Mustermann", gender: "male", nationality: "Deutschland", age: 27, aktuelleELOZahl: 2300, besteELOZahl: 2400, titel: "Weltmeister 2019", beschreibung: "Schachspieler"),
                player2: Player(name: "Magnus Carlsen", gender: "male", nationality: "Norwegen", age: 23, aktuelleELOZahl: 2030, besteELOZahl: 2340, titel: "Weltmeister 2023", beschreibung: "Schachspieler")
            )
            .padding(.top, 10)
        }
        .onDisappear {
            stopTimer()
        }
    }

    // Funktion zum Starten des Spiels
    func startGame() {
        if !hasStarted {
            hasStarted = true // Markiere das Spiel als gestartet
            isPaused = false // Setze Pause auf false
            startTimer() // Starte den Timer
            executeMoves(chessBoard: chessBoard, movesWithDelays: movesWithDelays)
        }
    }

    // Funktion zur Ausführung der Züge mit den entsprechenden Verzögerungen
    func executeMoves(chessBoard: ChessBoard, movesWithDelays: [(String, Double)]) {
        var delay: Double = currentDelay

        for (move, moveDelay) in movesWithDelays {
            delay += moveDelay

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if !isPaused {
                    if move == "0-0" {
                        performShortCastle(chessBoard: chessBoard) // Kurze Rochade
                    } else {
                        chessBoard.updateBoard(move: move) // Normaler Zug
                    }

                    // Zug zur entsprechenden Liste hinzufügen (neueste oben)
                    if isPlayer1Turn {
                        leftPlayerMoves.insert(move, at: 0) // Neuster Zug oben
                    } else {
                        rightPlayerMoves.insert(move, at: 0) // Neuster Zug oben
                    }

                    // Spieler wechseln
                    isPlayer1Turn.toggle()
                } else {
                    currentDelay = delay // Speichere den aktuellen Fortschritt
                }
            }
        }
    }
    
    func performShortCastle(chessBoard: ChessBoard) {
        if isPlayer1Turn {
            // Kurze Rochade für Spieler 1 (weiß, untere Reihe)
            if let king = chessBoard.board[7][4], let rook = chessBoard.board[7][7] {
                if king.type == "♚" && rook.type == "♜" {
                    chessBoard.board[7][6] = king // König nach g1
                    chessBoard.board[7][4] = nil // Ursprüngliches Königsfeld leeren
                    chessBoard.board[7][5] = rook // Turm nach f1
                    chessBoard.board[7][7] = nil // Ursprüngliches Turmfeld leeren
                }
            }
        } else {
            // Kurze Rochade für Spieler 2 (schwarz, obere Reihe)
            if let king = chessBoard.board[0][4], let rook = chessBoard.board[0][7] {
                if king.type == "♚" && rook.type == "♜" {
                    chessBoard.board[0][6] = king // König nach g8
                    chessBoard.board[0][4] = nil // Ursprüngliches Königsfeld leeren
                    chessBoard.board[0][5] = rook // Turm nach f8
                    chessBoard.board[0][7] = nil // Ursprüngliches Turmfeld leeren
                }
            }
        }

        chessBoard.objectWillChange.send() // Aktualisiere die Anzeige
    }


    // Timer starten
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTimer()
        }
    }

    // Timer stoppen
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // Pause/Weiter umschalten
    func togglePause() {
        isPaused.toggle()
        if isPaused {
            stopTimer()
        } else {
            startTimer()
        }
    }

    // Timer-Update: Reduziert nur die Zeit des aktiven Spielers
    func updateTimer() {
        if !isPaused {
            if isPlayer1Turn {
                if leftPlayerSeconds > 0 { leftPlayerSeconds -= 1 }
            } else {
                if rightPlayerSeconds > 0 { rightPlayerSeconds -= 1 }
            }
        }
    }

    // Zeitformatierung: Sekunden zu MM:SS
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ChessGameView()
}

