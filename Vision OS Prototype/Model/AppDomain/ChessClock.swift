//
//  Clock.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//


import Foundation

class ChessClock {
    public var secondsRemaining: Int
    public var isTicking: Bool = false
    
    private var timer: Timer?
    
    init(startingSeconds: Int) { self.secondsRemaining = startingSeconds }
    
    public func start() {
        self.isTicking = true
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    public func stop() {
        self.isTicking = false
        self.timer?.invalidate()
        self.timer = nil
    }
                             
    @objc private func tick() {
        self.secondsRemaining -= 1
        GameStateChangedNotificationCenter.shared.notifyClockTick(eventGuid: UUID())
    }
}
