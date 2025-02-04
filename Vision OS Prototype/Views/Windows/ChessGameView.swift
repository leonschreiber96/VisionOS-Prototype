//
//  ChessGameView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//

import SwiftUI

struct ChessGameView: View {
//    @StateObject var chessBoard = ChessEventViewModel(ChessEvent())
    
    @ObservedObject public var viewModel: ChessEventViewModel

    @State var leftPlayerSeconds = 330
    @State var rightPlayerSeconds = 285
    @State var isPlayer1Turn = true

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 10) { // Minimaler vertikaler Abstand zwischen den Elementen
            // Anzeige des aktuellen Spielers
            CurrentPlayerView(
                playerName: isPlayer1Turn ? "Anton Mustermann" : "Magnus Carlsen",
                remainingTime: isPlayer1Turn ? timeString(from: leftPlayerSeconds) : timeString(from: rightPlayerSeconds)
            )

            // HStack: Zuglisten + Schachbrett
            HStack(spacing: 50) { // Abstand zwischen Zuglisten und Schachbrett
                PlayerMovesView(
                    playerName: "Anton Mustermann",
                    moves: viewModel.whiteMoves,
                    remainingTime: timeString(from: leftPlayerSeconds)
                )
                .frame(width: 120)
                .border(Color.red) // Debug-Rahmen

//                ChessBoardView(chessBoard: chessBoard)
//                    .border(Color.green) // Debug-Rahmen
                ChessGame2DView(viewModel: ChessBoard2DViewModel.createInstance(from: viewModel.eventObject))
                    .frame(width: 1360 * 0.33, height: 1360 * 0.33)

                PlayerMovesView(
                    playerName: "Magnus Carlsen",
                    moves: viewModel.blackMoves,
                    remainingTime: timeString(from: rightPlayerSeconds)
                )
                .frame(width: 120)
                .border(Color.blue) // Debug-Rahmen
                
                Button(action: {
                    viewModel.eventObject.game.addMove(from: .A1, to: .A8)
                    
                    guard let move = viewModel.eventObject.game.moveHistory.last else {
                        return
                    }
                    
                    GameStateChangedNotificationCenter.shared.notifyMove(move: move, eventGuid: viewModel.eventObject.guid)
                }) {
                    Text("Tap me!")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            // PlayerInfoView unterhalb des Schachbretts
            PlayerInfoView(
                player1: Player(name: "Anton Mustermann", gender: "male", nationality: "Deutschland", age: 27, aktuelleELOZahl: 2300, besteELOZahl: 2400, titel: "Weltmeister 2019", beschreibung: "Schachspieler"),
                player2: Player(name: "Magnus Carlsen", gender: "male", nationality: "Norwegen", age: 23, aktuelleELOZahl: 2030, besteELOZahl: 2340, titel: "Weltmeister 2023", beschreibung: "Schachspieler")
            )
            .padding(.top, 10) // Kleiner Abstand nach oben
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
        .padding(.horizontal, 10) // Außenabstand minimiert
        .background(Color.gray.opacity(0.1))
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
    let vm = ChessEventViewModel(event: DummyData.generateRandomEvent())
    ChessGameView(viewModel: vm)
}
