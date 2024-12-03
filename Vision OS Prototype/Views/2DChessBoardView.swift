//
//  ChessBoardView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//
//Zusammenfassung des Codes:
//1)Erstellt ein 8x8-Schachbrett:
//Das Schachbrett wird mit einem typischen weißen und grauen Muster dargestellt.
//
//2)Zeigt Schachfiguren an:
//Über jedem Feld wird eine Schachfigur angezeigt, falls an dieser Position eine vorhanden ist.
//
//3)Reagiert dynamisch auf Änderungen:
//Wenn das ChessBoard-Objekt aktualisiert wird (z. B. durch einen Zug), wird die Ansicht automatisch neu gezeichnet.


import SwiftUI

struct ChessBoardView: View {
    @ObservedObject var chessBoard: ChessBoard

    var body: some View {
        VStack(spacing: 0) {
            // Schleife für die Reihen
            ForEach((0..<8).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    // Schleife für die Spalten
                    ForEach(0..<8, id: \.self) { col in
                        Rectangle()
                            .fill((row + col) % 2 == 0 ? Color.lightWood : Color.darkWood) // Helles und dunkles Holz
                            .frame(width: 50, height: 50)
                            .background(
                                Image((row + col) % 2 == 0 ? "lightWoodTexture" : "darkWoodTexture") // Texturen
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipped() // Texturen zuschneiden
                            .overlay(
                                Text(chessBoard.board[row][col]?.type ?? "") // Figuren hinzufügen
                                    .font(.system(size: 30))
                                    .foregroundColor(chessBoard.board[row][col]?.color == "white" ? .black : .white)
                            )
                    }
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.boardFrame) // Rahmen des Schachbretts
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5) // Schatten
        )
    }
}

#Preview {
    ChessGameView()
}
