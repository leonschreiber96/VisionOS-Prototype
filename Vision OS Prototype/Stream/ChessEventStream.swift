//
//  ChessEventStream.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

class ChessEventStream {
    /// Points to the resource of the video live stream.
    /// For the purpose of this project this will be just a prerecorded video file, but one could imagine using an actual livestream from the web
    public private(set) var liveStreamUri: String?
    
    /// Flag that denotes if the video stream is currently playing (`false` means it's paused).
    public var playing: Bool = false
    
    /// At which point in the video stream the user currently is waching.
    public var currentTimestamp: TimeInterval = 0
    
    /// Timestamps for the moves that happen in the streamed chess game, starting from Timestamp 00:00 of the video stream
    public var moveEventTimes: [TimeInterval] = []
    
    init(liveStreamUri: String? = "justcam") {
        self.liveStreamUri = liveStreamUri
    }
}
