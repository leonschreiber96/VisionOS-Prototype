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
    
    @Environment(AppModel.self) private var model
    
    @State private var isImmersiveSpaceOpen = false
    @State private var isLiveStreamOpen = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Player 1: Links ausgerichtet
                PlayerDetails(player: player1, alignment: .leading)

                // Duell-Symbol in der Mitte
                VStack {
                    Button(isImmersiveSpaceOpen ? "3D deaktivieren" : "3D aktivieren") {
                        Task {
                            if isImmersiveSpaceOpen {
                                await dismissImmersiveSpace()
                            } else {
                                await openImmersiveSpace(id: AppView.ChessBoard3D.rawValue)
                            }
                            isImmersiveSpaceOpen.toggle()
                        }
                    }
                    if model.currentStream?.liveStreamUris?.count ?? 0 > 0 {
                        Button("Livestream starten") {
                            if (isLiveStreamOpen) {
                                dismissWindow(id: AppView.VideoStreamWindow.rawValue)
                            } else {
                                openWindow(id: AppView.VideoStreamWindow.rawValue)
                            }
                            isLiveStreamOpen.toggle()
                        }
                        .opacity(supportsMultipleWindows ? 1 : 0)
                        .tint(Color(red: 0.98, green: 0.20, blue: 0.35))
                    }
                }

                // Player 2: Rechts ausgerichtet
                PlayerDetails(player: player2, alignment: .trailing)
            }
        }
        .padding([.leading, .trailing], 100)
    }
}

#Preview {
//    ChessGameView()
}
