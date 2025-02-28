//
//  ChessGameView.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//

import SwiftUI

struct MovesView: View {
    @ObservedObject var viewModel: ChessEventStreamViewModel
    let color: PieceColor
    
    var body: some View {
        ScrollView {
            List(viewModel.whiteMovesUntilCurrentTimestamp) {move in
                Text(move.getAlgebraicNotation())
            }
        }
        .frame(maxHeight: 900) // Maximale Höhe der Zugliste
        .padding()
        .background(Color.black.opacity(0.5)) // Hintergrund für die Zugliste
        .cornerRadius(10)
    }
}

struct ChessEventView: View {
//    @StateObject var chessBoard = ChessEventViewModel(ChessEvent())
    
    @ObservedObject public var viewModel: ChessEventStreamViewModel

    @State var leftPlayerSeconds = 330
    @State var rightPlayerSeconds = 285
    @State var isPlayer1Turn = true
    
    @Environment(AppModel.self) private var model

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 40) {
                VStack {
                    Text(viewModel.streamObject.eventObject.players.white.name)
                        .font(.title)
                    List(viewModel.streamObject.movesUntilCurrentTimestamp.filter{ $0.movedPiece.color == .white}) { move in
                        Text(move.getAlgebraicNotation())
                    }
                }

                ChessBoard2DView(viewModel: ChessBoard2DViewModel(from: viewModel.streamObject))
                    .frame(width: 1360 * 0.3, height: 1360 * 0.3)
                
                VStack {
                    Text(viewModel.streamObject.eventObject.players.black.name)
                        .font(.title)
                    List(viewModel.streamObject.movesUntilCurrentTimestamp.filter{ $0.movedPiece.color == .black}) { move in
                        Text(move.getAlgebraicNotation())
                    }
                }
            }
            
            HStack {
                // Fortschrittsanzeige (Slider)
                Slider(value: Binding(
                    get: { Double(viewModel.streamObject.currentTimestamp) },
                    set: {
                        viewModel.streamObject.currentTimestamp = TimeInterval($0)
                        StreamScrubbingNotificationCenter.shared.notifyScrub(sender: viewModel.streamObject.guid, to: TimeInterval($0))
                    }
                ), in: 0...min(Double(model.currentTime - model.startTime), viewModel.streamObject.moveEventTimes.last ?? 0))
                .padding(.horizontal, 20)

                Button(action: playPause) {
                    Image(systemName: viewModel.streamObject.playing ? "pause.fill" : "play.fill")
                        .font(.title)
                }
                .padding()
            }

            // PlayerInfoView unterhalb des Schachbretts
            PlayerInfoView(
                player1: viewModel.streamObject.eventObject.players.white,
                player2: viewModel.streamObject.eventObject.players.black
            )
            .padding(.top, 10) // Kleiner Abstand nach oben
        }
        .padding(.horizontal, 10) // Außenabstand minimiert
        .background(Color.gray.opacity(0.1))
        .onAppear {
            model.currentStream = viewModel.streamObject
        }
    }

    func playPause() {
        if viewModel.streamObject.playing {
            viewModel.streamObject.pauseStream()
            StreamScrubbingNotificationCenter.shared.notifyPlayPause(sender: viewModel.streamObject.guid, newState: .pause)
        } else {
            viewModel.streamObject.startStream()
            StreamScrubbingNotificationCenter.shared.notifyPlayPause(sender: viewModel.streamObject.guid, newState: .play)
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
    let vm = ChessEventStreamViewModel(stream: DummyData.generateRandomStream())
    ChessEventView(viewModel: vm)
}
