//
//  AppModel.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 12.11.24.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    var streamOpen: Bool = false
    var currentStream: ChessEventStream?
    var showingLiveStream: Bool = false
    var showing3DChessBoard: Bool = false
    
    var startTime: TimeInterval = Date().timeIntervalSince1970
    var currentTime: TimeInterval = Date().timeIntervalSince1970
    private var timer: Task<Void, Never>?
    var currentTimeString: String {
        let date = Date(timeIntervalSince1970: currentTime)

        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm:ss"
        
        let dateTimeString = formatter.string(from: date)
        return dateTimeString
    }
    
    // Create dummy data for prototyping purposes, since an actual live stream and game data API doesn't exist yet
    var availableStreams: [ChessEventStream] = [
        DummyData.getPrerecordedGameStream(),
        DummyData.generateRandomStream(),
        DummyData.generateRandomStream(),
        DummyData.generateRandomStream(),
        DummyData.generateRandomStream(),
    ]
    
    init() {
        startTimer()
        availableStreams.forEach {
            $0.startStream()
            let clock = $0.eventObject.game.colorOnTurn == .white ? $0.eventObject.clocks.white : $0.eventObject.clocks.black
            clock.start()   
        }
    }
    
    private func startTimer() {
        timer = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1)) // Sleep for 1 second
                await MainActor.run { self.currentTime += 1 } // Update safely on the main actor
            }
        }
    }
}
