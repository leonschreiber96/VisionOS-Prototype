//
//  PlayerInfoView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//
//Die PlayerInfoView ist eine SwiftUI-Ansicht, die die Informationen von zwei Schachspielern anzeigt. Hier wird das Layout erstellt, das die Namen und Informationen zu den Spieler auf dem Bildschirm darstellt.

import SwiftUI

struct PlayerDetails: View {
    let player: Player
    let alignment: HorizontalAlignment // Steuerung der Ausrichtung (links/rechts)

    var body: some View {
        VStack(alignment: alignment, spacing: 8) {
            // Name, Titel und Avatar
            HStack {
                VStack(alignment: alignment == .leading ? .leading : .trailing, spacing: 4) {
                    Text(player.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(player.titel)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }

            // Zusätzliche Details (Alter, Nationalität, etc.)
            VStack(alignment: alignment == .leading ? .leading : .trailing, spacing: 4) {
                Text("Alter: \(player.age)")
                    .font(.subheadline)
                Text("Nationalität: \(player.nationality)")
                    .font(.subheadline)
            }
            .foregroundColor(.white)

            Divider() // Trennt die ELO-Informationen

            // ELO-Zahlen
            VStack(alignment: alignment == .leading ? .leading : .trailing, spacing: 4) {
                Text("ELO: \(player.aktuelleELOZahl)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}


#Preview {
//    ChessGameView()
}
