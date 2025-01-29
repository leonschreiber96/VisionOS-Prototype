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
    let game: ChessGame = ChessGame()
    
    public var boardBounds: (width: Float, height: Float, depth: Float) = (width: 0.0, height: 0.0, depth: 0.0)
    public var board: ChessBoard3D?
    
    @MainActor required init () {
        super.init()
    }
    
    @MainActor public func setup() async throws {
        let chessBoard = ChessBoard3D(realityKitModelIdentifier: "ChessBoard", game: self.game)
        try await chessBoard.loadModel()
        self.board = chessBoard
        
        self.children.append(chessBoard.getModelEntity()!)
        
        update(scale: SIMD3(repeating: 0.04), position: .zero)
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
    func update(scale: SIMD3<Float>, position: SIMD3<Float>) {
        print("Update")
        // Scale and position the entire entity.
        move(
            to: Transform(
                scale: scale,
                rotation: .init(angle: 0.2, axis: [0, 1, 0]),
                translation: position
            ),
            relativeTo: parent)
    }
}
