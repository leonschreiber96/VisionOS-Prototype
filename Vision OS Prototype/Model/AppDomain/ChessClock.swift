//
//  Clock.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import Foundation

/**
 Represents a single chess clock that counts down for a single player.
 The clock starts with a given amount of time and decreases by one second at a time.
 
 The `ChessClock` can be started and stopped, and it will notify listeners about each tick event.
 */
class ChessClock {
    public var secondsRemaining: Int
    public var isTicking: Bool = false
    
    private var timer: Timer?
    
    /**
    Initializes a chess clock with a specified starting time.
    
    - Parameter startingSeconds: The initial time in seconds for the clock.
    */
    init(startingSeconds: Int) { self.secondsRemaining = startingSeconds }
    
   /**
   Starts the clock, decreasing time every second.
   If already running, calling this method has no effect.
   */
    public func start() {
        if (self.isTicking) { return }
        self.isTicking = true
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    /**
     Stops the clock, preventing further countdown.
     If already stopped, calling this method has no effect.
     */
    public func stop() {
        if (!self.isTicking) { return }
        self.isTicking = false
        self.timer?.invalidate()
        self.timer = nil
    }

    @objc private func tick() {
        self.secondsRemaining -= 1
        
        // Notify all who have subscribed to the game state of this clock's chess event that the clock ticked.
        GameStateChangedNotificationCenter.shared.notifyClockTick(eventGuid: UUID())
    }
}
