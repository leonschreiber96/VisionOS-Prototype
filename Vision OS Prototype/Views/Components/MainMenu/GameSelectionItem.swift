
//
//  GameSelectionItem.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 22.01.25.
//

import SwiftUI
import UIKit // Import UIKit to access NSString and related methods


struct GameSelectionItem: View, Identifiable {
    let event: ChessEvent
    var id: UUID = UUID()

    var body: some View {
        VStack {
            PlayerInfo(nationality: event.players.black.nationality,
                       playerName: event.players.black.name,
                       playerElo: event.players.black.aktuelleELOZahl,
                       playerColor: .black,
                       gameOver: event.game.isGameOver,
                       gameResult: event.game.result,
                       secondsRemaining: event.clocks.black.secondsRemaining)
            .frame(width: 1360 * 0.33, height: 1360 * 0.1)

//            ChessGame2DView(boardState: event.game.board)
//                .frame(width: 1360 * 0.33, height: 1360 * 0.33)

            PlayerInfo(nationality: event.players.white.nationality,
                       playerName: event.players.white.name,
                       playerElo: event.players.white.aktuelleELOZahl,
                       playerColor: .white,
                       gameOver: event.game.isGameOver,
                       gameResult: event.game.result,
                       secondsRemaining: event.clocks.white.secondsRemaining)
            .frame(width: 1360 * 0.33, height: 1360 * 0.1)
        }
    }
}



#Preview {
    let game = ChessGame()
    
    game.addMove(from: .E2, to: .E4)
    game.addMove(from: .B8, to: .C6)
    
    let white = Player(name: "Franz", gender: "male", nationality: "Germany", age: 28, aktuelleELOZahl: 2963, besteELOZahl: 3623, titel: "GM", beschreibung: "A dude")
    let black = Player(name: "Francesca", gender: "female", nationality: "Italy", age: 26, aktuelleELOZahl: 2700, besteELOZahl: 2550, titel: "WGM", beschreibung: "A rising star in the chess world.")
    let event = ChessEvent(game: game, players: (white: white, black: black), gameTime: 300)
    
    game.declareWinner(color: .black)
    
    return GameSelectionItem(event: event)
}

private struct PlayerInfo: View {
    let nationality: String
    let playerName: String
    let playerElo: Int
    let playerColor: PieceColor
    let gameOver: Bool
    let gameResult: ChessGameResult?
    let secondsRemaining: Int
    
    var body: some View {
        HStack {
            Image(nationality.lowercased())
                .resizable()
                .scaledToFit()
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white, location: 0),  // Stronger fade starts at 30%
                            .init(color: .clear, location: 0.9)   // Fully transparent at 60%
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing  // Fades out to the right
                    )
                )
            
            VStack(alignment: .leading) {
                Text(playerName)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Text(String(playerElo))
                    .font(.system(size: 25))
            }
            .padding(0)
            
            Spacer()
            
            if gameOver && gameResult == .checkmate(for: playerColor) {
                Image("medal")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            } else if gameOver && gameResult == .draw {
                Text("Draw")
                    .font(.system(size: 30))
                    .padding(.trailing, 20)
            } else {
                var formattedTime: String {
                    let minutes = secondsRemaining / 60
                    let seconds = secondsRemaining % 60
                    return String(format: "%02d:%02d", minutes, seconds)
                }
                Text(formattedTime)
                    .font(.system(size: 30))
                    .monospacedDigit()
                    .padding(.trailing, 20)
            }
        }
        .background(Color.black)
        .cornerRadius(20)
    }
}
