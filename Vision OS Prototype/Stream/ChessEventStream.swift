//
//  ChessEventStream.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

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
    
    init(event: ChessEvent, liveStreamUris: [URL]? = nil) {
        self.eventObject = event
        self.liveStreamUris = liveStreamUris
    }
}
