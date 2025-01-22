//
//  PieceInventory.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 22.01.25.
//


import RealityKit
import SwiftUI
import RealityKitContent

class PieceInventory {
    private let whiteModels: [PieceType:Entity]
    private let blackModels: [PieceType:Entity]
    
    init(whiteModels: [PieceType:Entity], blackModels: [PieceType:Entity]) {
        self.whiteModels = whiteModels
        self.blackModels = blackModels
    }
    
    public func getModel(color: PieceColor, type: PieceType) -> Entity {
        let inventorySection = color == .white ? self.whiteModels : self.blackModels
        return inventorySection[type]!.clone(recursive: true) // Documentation: why clone? → entities are references and must be able to move one knight and the other not
    }
}