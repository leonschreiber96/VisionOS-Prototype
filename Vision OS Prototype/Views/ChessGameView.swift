//
//  ChessGameView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//

import SwiftUI

struct ChessGameView: View {
    @StateObject var chessBoard = ChessBoard()
    
    let player1 = Player(name: "Anton Mustermann", gender: "male", nationality: "Deutschland", age: 27, aktuelleELOZahl: 2300, besteELOZahl: 2400, titel: "Weltmeister 2019", beschreibung: "Schachspieler")
    
    let player2 = Player(name: "Magnus Carlsen", gender: "male", nationality: "Norwegen", age: 23, aktuelleELOZahl: 2030, besteELOZahl: 2340, titel: "Weltmeister 2023", beschreibung: "Schachspieler")

    var body: some View {
        VStack {
            ChessBoardView(chessBoard: chessBoard)
            PlayerInfoView(player1: player1, player2: player2)
        }
        .padding()
    }
}

#Preview {
    ChessGameView()
}
