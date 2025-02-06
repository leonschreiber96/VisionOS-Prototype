//
//  PlayerInfoView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//
//Die PlayerInfoView ist eine SwiftUI-Ansicht, die die Informationen von zwei Schachspielern anzeigt. Hier wird das Layout erstellt, das die Namen und Informationen zu den Spieler auf dem Bildschirm darstellt.

import SwiftUI

struct PlayerInfoView: View {
    let player1: Player
    let player2: Player
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State private var isImmersiveSpaceOpen = false
    @State private var isLiveStreamOpen = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Player 1: Links ausgerichtet
                PlayerDetails(player: player1, color: Color.blue, alignment: .leading)

                // Duell-Symbol in der Mitte
                VStack {
                    Button(isImmersiveSpaceOpen ? "3D deaktivieren" : "3D aktivieren") {
                        Task {
                            if isImmersiveSpaceOpen {
                                await dismissImmersiveSpace()
                            } else {
                                await openImmersiveSpace(id: "ChessBoard3DView")
                            }
                            isImmersiveSpaceOpen.toggle()
                        }
                    }
                    Button(isLiveStreamOpen ? "Livestream deaktivieren" : "Livestream aktivieren") {
                        if (isLiveStreamOpen) {
                            dismissWindow(id: "multiview")
                        } else {
                            openWindow(id: "multiview")
                        }
                        isLiveStreamOpen.toggle()
                    }
                    .opacity(supportsMultipleWindows ? 1 : 0)
                }

                // Player 2: Rechts ausgerichtet
                PlayerDetails(player: player2, color: Color.red, alignment: .trailing)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.7))
                .shadow(color: Color.black.opacity(0.7), radius: 8, x: 0, y: 4)
        )
        .padding([.leading, .trailing], 100)
    }
}

struct PlayerDetails: View {
    let player: Player
    let color: Color
    let alignment: HorizontalAlignment // Steuerung der Ausrichtung (links/rechts)

    var body: some View {
        VStack(alignment: alignment, spacing: 8) {
            // Name, Titel und Avatar
            HStack {
                if alignment == .leading {
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(player.name.prefix(1)) // Initiale des Namens
                                .font(.title)
                                .foregroundColor(.white)
                        )
                }

                VStack(alignment: alignment == .leading ? .leading : .trailing, spacing: 4) {
                    Text(player.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(player.titel)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                if alignment == .trailing {
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(player.name.prefix(1)) // Initiale des Namens
                                .font(.title)
                                .foregroundColor(.white)
                        )
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
