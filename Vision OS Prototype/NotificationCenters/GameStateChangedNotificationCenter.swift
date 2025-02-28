//
//  GameStateChangedNotification.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 29.01.25.
//

import Foundation

class GameStateChangedNotificationCenter {
    static let shared = GameStateChangedNotificationCenter()
    
    private init() {} // Singleton pattern
    
    private var moveHandlers: [UUID:[(ChessMove) -> Void]] = [:]
    private var clockTickhandlers: [UUID:[() -> Void]] = [:]
    
    /// Register an observer with a closure that accepts a `ChessMove` object
    public func registerMoveHandler(eventGuid: UUID, observer: @escaping (ChessMove) -> Void) {
        guard var handlerCollection = self.moveHandlers[eventGuid] else {
            self.moveHandlers[eventGuid] = [observer]
            return
        }
        handlerCollection.append(observer)
    }
    
    public func registerClockTickHandler(eventGuid: UUID, observer: @escaping () -> Void) {
        guard var handlerCollection = self.clockTickhandlers[eventGuid] else {
            self.clockTickhandlers[eventGuid] = [observer]
            return
        }
        handlerCollection.append(observer)
    }
    
    public func notifyMove(move: ChessMove, eventGuid: UUID) {
        for handler in self.moveHandlers[eventGuid] ?? [] {
            handler(move)
        }
    }
    
    public func notifyClockTick(eventGuid: UUID) {
        for handler in self.clockTickhandlers[eventGuid] ?? [] {
            handler()
        }
    }
}
