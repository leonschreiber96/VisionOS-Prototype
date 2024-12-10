//
//  PlayerMovesView.swift
//  Vision OS Prototype
//
//  Created by Albnor Sahiti on 08.12.24.
//

import SwiftUI

struct PlayerMovesView: View {
    let playerName: String          // Name des Spielers
    let moves: [String]             // Liste der gespielten Züge
    let remainingTime: String       // Verbleibende Zeit als String im Format MM:SS

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Spielername
            Text(playerName)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            // Liste der Spielzüge
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(moves.indices, id: \.self) { index in
                        Text("\(index + 1). \(moves[index])") // Nummerierter Zug
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxHeight: 200) // Maximale Höhe der Zugliste
            .padding()
            .background(Color.black.opacity(0.5)) // Hintergrund für die Zugliste
            .cornerRadius(10)

            Spacer()

            // Verbleibende Zeit
            Text("Verbleibende Zeit:")
                .font(.subheadline)
                .foregroundColor(.white)

            Text(remainingTime)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .padding()
                .background(Color.black.opacity(0.7)) // Hintergrund für die Zeit
                .cornerRadius(10)
        }
        .padding()
        .frame(width: 150) // Festgelegte Breite der Ansicht
    }
}
