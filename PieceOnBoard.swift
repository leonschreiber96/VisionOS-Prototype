//
//  PieceOnBoard.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import RealityKit
import SwiftUI
import RealityKitContent
import Foundation

class ChessPiece3D: Identifiable {
    public let id = UUID()
    public let piece: PieceType
    public let color: PieceColor
    public let entity: Entity
    public var location: ChessBoardField
    
    init(piece: PieceType, color: PieceColor, location: ChessBoardField, entity: Entity) {
        self.piece = piece
        self.color = color
        self.entity = entity
        self.location = location
    }
}
