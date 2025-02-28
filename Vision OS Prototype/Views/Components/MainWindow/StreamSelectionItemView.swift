
//
//  GameSelectionItem.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 22.01.25.
//

import SwiftUI

struct StreamSelectionItemView: View {
    public let stream: ChessEventStream
    
    var body: some View {
        VStack {
            PlayerInfo(nationality: stream.eventObject.players.black.nationality,
                       name: stream.eventObject.players.black.name,
                       elo: stream.eventObject.players.black.aktuelleELOZahl,
                       playerColor: .black,
                       gameResult: stream.eventObject.game.result,
                       secondsRemaining: stream.eventObject.clocks.black.secondsRemaining)
            .frame(width: 1360 * 0.3, height: 1360 * 0.05)

            ZStack {
                ChessBoard2DView(viewModel: ChessBoard2DViewModel(from: stream))
                    .border(Color(red: 0.98, green: 0.20, blue: 0.35), width: stream.liveStreamUris?.count ?? 0 > 0 ? 8 : 0)
                    .cornerRadius(15)
                
                if (stream.liveStreamUris?.count ?? 0 > 0) {
                    Image("livestream")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 1360 * 0.215)
                        .padding(.leading, 1360 * 0.175)
                }
            }
            .frame(width: 1360 * 0.3, height: 1360 * 0.3)

            PlayerInfo(nationality: stream.eventObject.players.white.nationality,
                       name: stream.eventObject.players.white.name,
                       elo: stream.eventObject.players.white.aktuelleELOZahl,
                       playerColor: .white,
                       gameResult: stream.eventObject.game.result,
                       secondsRemaining: stream.eventObject.clocks.white.secondsRemaining)
            .frame(width: 1360 * 0.3, height: 1360 * 0.05)
        }
    }
}



#Preview {
    let game = ChessGame()
    
    game.addMove(from: .E2, to: .E4)
    game.addMove(from: .B8, to: .C6)
    
    let white = Player(name: "Franz", gender: "male", nationality: "Germany", age: 28, aktuelleELOZahl: 2963, besteELOZahl: 3623, titel: "GM", beschreibung: "A dude")
    let black = Player(name: "Francesca", gender: "female", nationality: "Italy", age: 26, aktuelleELOZahl: 2700, besteELOZahl: 2550, titel: "WGM", beschreibung: "A rising star in the chess world.")
    
    game.declareWinner(color: .black)
    
    let event: ChessEvent = .init(game: game, players: (white: white, black: black), gameTime: 300)
    let stream: ChessEventStream = .init(event: event, liveStreamUris: [defaultVideos[0].url])
    
    return StreamSelectionItemView(stream: stream)
}

private struct PlayerInfo: View {
    let nationality: String
    let name: String
    let elo: Int
    let playerColor: PieceColor
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
                Text(name)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                Text(String(elo))
                    .font(.system(size: 20))
            }
            .padding(0)
            
            Spacer()
            
            if gameResult == .checkmate(for: playerColor) {
                Image("medal")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            } else if gameResult == .draw {
                Text("Draw")
                    .font(.system(size: 25))
                    .padding(.trailing, 20)
            } else {
                var formattedTime: String {
                    let minutes = secondsRemaining / 60
                    let seconds = secondsRemaining % 60
                    return String(format: "%02d:%02d", minutes, seconds)
                }
            }
        }
        .background(Color.black)
        .cornerRadius(20)
    }
}
