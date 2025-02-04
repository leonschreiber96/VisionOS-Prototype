//
//  GameStateChangedNotification.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

class StreamScrubbingNotificationCenter {
    static let shared = StreamScrubbingNotificationCenter()
    
    private init() {} // Singleton pattern
    
    private var playPauseHandlers: [UUID:(PlayingState) -> Void] = [:]
    private var scrubHandlers: [UUID:(TimeInterval) -> Void] = [:]
    
    public func registerPlayPauseHandler(for targetVideo: UUID, observer: @escaping (PlayingState) -> Void) { playPauseHandlers[targetVideo] = observer }
    public func registerScrubHandler(for targetVideo: UUID, observer: @escaping (TimeInterval) -> Void) { scrubHandlers[targetVideo] = observer}
    public func deRegisterPlayPauseHandler(for targetVideo: UUID) { playPauseHandlers[targetVideo] = nil }
    public func deRegisterScrubHandler(for targetVideo: UUID) { scrubHandlers[targetVideo] = nil }
    
    public func notifyPlayPause(sender: UUID, newState: PlayingState) {
        for (video, handler) in self.playPauseHandlers {
            if video == sender { continue }
            handler(newState)
        }
    }
    
    public func notifyScrub(sender: UUID, to targetTimestamp: TimeInterval) {
        for (video, handler) in self.scrubHandlers {
            if video == sender { continue }
            handler(targetTimestamp)
        }
    }
}

enum PlayingState {
    case play
    case pause
}
