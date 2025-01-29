//
//  PieceInventory.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 22.01.25.
//


import RealityKit
import SwiftUI
import RealityKitContent

/**
 Contains an inventory of SwiftUI `Entity` objects that correspond to chess pieces and can be added as children to a SwiftUI view hierarchy.
 
 Use this class to retrieve entities for all chess pieces that you want to add to the chess board (e.g., when initializing or promoting a pawn).
 */
class PieceInventory {
    private let whiteModels: [PieceType:Entity]
    private let blackModels: [PieceType:Entity]
    
    init(whiteModels: [PieceType:Entity], blackModels: [PieceType:Entity]) {
        self.whiteModels = whiteModels
        self.blackModels = blackModels
    }
    
    /**
     Retrieve the SwiftUI `Entity` used to represent a piece of a certain `color` and `type`.
     
     - Parameter color: The color of the specified piece (e.g., `PieceColor.white`)
     - Parameter type:  The type of the specified piece (e.g., `PieceType.pawn`)
     */
    public func getModel(color: PieceColor, type: PieceType) -> Entity {
        let inventorySection: [PieceType:Entity] = (color == .white ? self.whiteModels : self.blackModels)
        
        guard let inventoryModel = inventorySection[type] else {
            fatalError("Could not find model for piece of type \(type) and color \(color)")
        }
        
        // Return a copy of the Entity, so we we're able to request an independent one for each piece of this type)
        return inventoryModel.clone(recursive: true)
    }
}
