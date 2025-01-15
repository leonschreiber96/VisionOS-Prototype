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

    // Zugliste
    let moves = ["e2e4", "e7e5", "g1f3", "b8c6", "f1c4"]

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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

            // Button für Zugausführung
            Button(action: {
                executeMoves(on: chessBoard, moves: moves)
            }) {
                Text("Züge ausführen")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // PlayerInfoView unterhalb des Schachbretts
            PlayerInfoView(
                player1: Player(name: "Anton Mustermann", gender: "male", nationality: "Deutschland", age: 27, aktuelleELOZahl: 2300, besteELOZahl: 2400, titel: "Weltmeister 2019", beschreibung: "Schachspieler"),
                player2: Player(name: "Magnus Carlsen", gender: "male", nationality: "Norwegen", age: 23, aktuelleELOZahl: 2030, besteELOZahl: 2340, titel: "Weltmeister 2023", beschreibung: "Schachspieler")
            )
            .padding(.top, 10)
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.1))
    }

    // Funktion zur Ausführung der Züge
    func executeMoves(on chessBoard: ChessBoard, moves: [String]) {
        for (index, move) in moves.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                // Zug ausführen
                chessBoard.updateBoard(move: move)

                // Zug zur entsprechenden Liste hinzufügen
                if isPlayer1Turn {
                    leftPlayerMoves.append(move)
                } else {
                    rightPlayerMoves.append(move)
                }

                // Spieler wechseln
                isPlayer1Turn.toggle()
            }
        }
    }

    // Timer-Update: Reduziert nur die Zeit des aktiven Spielers
    func updateTimer() {
        if isPlayer1Turn {
            if leftPlayerSeconds > 0 { leftPlayerSeconds -= 1 }
        } else {
            if rightPlayerSeconds > 0 { rightPlayerSeconds -= 1 }
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

