//
//  CurrentPlayerTurnView.swift
//  Vision OS Prototype
//
//  Created by Albnor Sahiti on 08.12.24.
//

import SwiftUI

struct CurrentPlayerView: View {
    let playerName: String
    let remainingTime: String

    var body: some View {
        HStack {
            // Anzeige: Wer ist am Zug
            Text("\(playerName) ist am Zug")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)

            Spacer()

            // Anzeige: Verbleibende Zeit
            Text("Verbleibende Zeit: \(remainingTime)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
        }
        .padding(.horizontal, 340)
        .background(Color.black.opacity(0.01))
        .cornerRadius(10)
    }
}

#Preview {
//    ChessGameView()
}
