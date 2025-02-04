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
    var eventOpen: Bool = false
    var showingLiveStream: Bool = false
    var showing3DChessBoard: Bool = false
    
    var availableStreams: [ChessEventStream] = [
        DummyData.getPrerecordedGameStream(),
        DummyData.generateRandomStream(),
        DummyData.generateRandomStream(),
        DummyData.generateRandomStream(),
        DummyData.generateRandomStream(),
    ]
}
