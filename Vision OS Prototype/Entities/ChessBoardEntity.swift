//
//  ChessBoardEntity.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//

import RealityKit
import SwiftUI
import RealityKitContent

class ChessBoardEntity : Entity {
    // MARK: - Internal State
    private var testBool: Bool = false
    
    @MainActor required init () {
        super.init()
    }
    
    init(testBool: Bool) async {
        super.init()
        
        guard let chessBoard = await RealityKitContent.entity(named: "ChessBoard") else {
            fatalError("Could not load chess board asset.")
        }
        
        self.addChild(chessBoard)
        
        update()
    }
    
    // MARK: - Updates

    /// Updates all the entity's configurable elements.
    ///
    /// - Parameters:
    ///   - configuration: Information about how to configure the Earth.
    ///   - satelliteConfiguration: An array of configuration structures, one
    ///     for each artificial satellite.
    ///   - moonConfiguration: A satellite configuration structure that's
    ///     specifically for the Moon.
    ///   - animateUpdates: A Boolean that indicates whether changes to certain
    ///     configuration values should be animated.
    func update() {

        // Scale and position the entire entity.
        move(
            to: Transform(
                scale: SIMD3(repeating: 0.01),
                rotation: .init(angle: 0, axis: [0, 1, 0]),
                translation: .zero),
            relativeTo: parent)
    }
}
