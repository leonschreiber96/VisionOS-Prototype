//
//  ChessBoardEntity.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//

import RealityKit
import SwiftUI
import RealityKitContent

final class ChessBoardEntity : Entity {
    let stream: ChessEventStream
    
    public var boardBounds: (width: Float, height: Float, depth: Float) = (width: 0.0, height: 0.0, depth: 0.0)
    public var board: ChessBoard3D?
    
    @MainActor required init (stream: ChessEventStream) {
        self.stream = stream
        super.init()
    }
    
    @MainActor @preconcurrency required init() {
        fatalError("init() has not been implemented")
    }
    
    @MainActor public func setup() async throws {
        let chessBoard = ChessBoard3D(realityKitModelIdentifier: "ChessBoard", stream: self.stream)
        try await chessBoard.loadModel()
        self.board = chessBoard
        
        self.children.append(chessBoard.getModelEntity()!)
        
        update(scale: SIMD3(repeating: 0.04), position: .zero)
    }
    
    func update(scale: SIMD3<Float>, position: SIMD3<Float>) {
        print("Update")
        // Scale and position the entire entity.
        move(
            to: Transform(
                scale: scale,
                rotation: .init(angle: 0.0, axis: [0, 1, 0]),
                translation: position
            ),
            relativeTo: parent)
    }
}
