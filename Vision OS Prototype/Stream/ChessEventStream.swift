//
//  ChessEventStream.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

/**
 Represents a stream that belongs to a chess event.
 
 - Contains information about the live streams associated with it
 - Contains stateful information about the playback state
 - Contains information about when chess moves were made (→ needed to "travel through time" when scrubbing)
 */
class ChessEventStream {
    public let guid: UUID = UUID()
    
    /// Points to the resource of the video live stream.
    /// For the purpose of this project this will be just a prerecorded video file, but one could imagine using an actual livestream from the web
    let liveStreamUris: [URL]?
    
    let eventObject: ChessEvent
    
    /// Flag that denotes if the video stream is currently playing (`false` means it's paused).
    var playing: Bool = false
    
    /// At which point in the video stream the user currently is waching.
    var currentTimestamp: TimeInterval = 0
    
    /// Timestamps for the moves that happen in the streamed chess game, starting from Timestamp 00:00 of the video stream
    var moveEventTimes: [TimeInterval] = []
    
    var movesUntilCurrentTimestamp: [ChessMove] {
        let moveCount = moveEventTimes.count { $0 < currentTimestamp }
        let moves = Array(eventObject.game.moveHistory[..<moveCount])
        return moves
    }
    
    private var clockTimer: Timer?
    
    init(event: ChessEvent, liveStreamUris: [URL]? = nil) {
        self.eventObject = event
        self.liveStreamUris = liveStreamUris
        
        StreamScrubbingNotificationCenter.shared.registerPlayPauseHandler(for: self.guid, observer: { newState in
            if newState == .pause {
                self.pauseStream()
            } else {
                self.startStream()
            }
        })
    }
    
    deinit {
        self.removeTimer()
    }
    
    func startStream() {
        self.playing = true
        guard clockTimer == nil else { return }
        self.clockTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let movesMadeBefore: [ChessMove] = self.movesUntilCurrentTimestamp
            self.currentTimestamp += 1
            let movesMadeAfter: [ChessMove] = self.movesUntilCurrentTimestamp
            
            let newMoves: [ChessMove] = Array(movesMadeAfter.dropFirst(movesMadeBefore.count))
            
            newMoves.forEach { move in
                GameStateChangedNotificationCenter.shared.notifyMove(move: move, eventGuid: self.eventObject.guid)
            }
        }

    }
    
    func pauseStream() {
        self.playing = false
        self.removeTimer()
    }
    
    private func removeTimer() {
        self.clockTimer?.invalidate()
        self.clockTimer = nil
    }
}
