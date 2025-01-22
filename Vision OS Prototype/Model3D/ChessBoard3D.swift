//
//  ChessBoard3D.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import RealityKit
import SwiftUI
import RealityKitContent

@MainActor
class ChessBoard3D {
    private var realityKitModelIdentifier: String = "ChessBoard"
    private var gameObject: ChessGame
    
    private var baseModel: Entity?
    private var meshCollection: Entity.ChildCollection?
    private var boardEntity: Entity?
    
    private var inventory: PieceInventory?
    
    public var piecesOnBoard: [ChessPiece3D] = []
    
    private var boardBounds: (width: Float, height: Float, depth: Float) = (width: 0.0, height: 0.0, depth: 0.0)
    
    init(realityKitModelIdentifier: String?, game: ChessGame?) {
        if (realityKitModelIdentifier != nil) { self.realityKitModelIdentifier = realityKitModelIdentifier! }
        self.gameObject = game ?? ChessGame(gameTime: 300)
    }
    
    public func loadModel() async throws {
        if (self.isModelLoaded()) { return }
        
        guard let chessBoard = try await RealityKitContent.entity(named: self.realityKitModelIdentifier) else {
            fatalError("Could not load chess board asset!")
        }
        
        self.baseModel = chessBoard
        
        try await self.extractMeshes()
        try await self.fillInventory()
        
        // Remove all piece meshes from the model so that we can add all initial pieces from the inventory instead
        self.meshCollection!
            .filter { mesh in mesh.name.starts(with: "Cylinder") }
            .forEach { pieceMesh in pieceMesh.removeFromParent() }
        
        self.gameObject.board.getAllPieces()
            .forEach { piece in
                let mesh = self.inventory!.getModel(color: piece.color, type: piece.type)
                self.meshCollection!.append(mesh)
                self.piecesOnBoard.append(ChessPiece3D(piece: piece.type, color: piece.color, location: piece.position, entity: mesh))
            }
        
        let newBounds = self.boardEntity!.visualBounds(relativeTo: self.boardEntity)
        
        let min = newBounds.min
        let max = newBounds.max

        let width = max.x - min.x
        let height = max.y - min.y
        let depth = max.z - min.z
        
        self.boardBounds = (width: width, height: height, depth: depth)
    }
    
    public func applyMove(from origin: ChessBoardField, to destination: ChessBoardField, duration: TimeInterval = 2.0) {
        self.animateMovement(from: origin, to: destination, duration: duration)
        self.gameObject.addMove(from: origin, to: destination)
        
        let piece3D = self.piecesOnBoard.first { piece in piece.location == origin }!
        piece3D.location = destination
    }
    
    public func initializePieces() {
        self.piecesOnBoard.forEach { piece in
            var origin: ChessBoardField?
            if (piece.piece == .pawn && piece.color == .white) { origin = ChessBoardField.A2 }
            else if (piece.piece == .rook && piece.color == .white) { origin = ChessBoardField.A1 }
            else if (piece.piece == .knight && piece.color == .white) { origin = ChessBoardField.B1 }
            else if (piece.piece == .bishop && piece.color == .white) { origin = ChessBoardField.C1 }
            else if (piece.piece == .queen && piece.color == .white) { origin = ChessBoardField.D1 }
            else if (piece.piece == .king && piece.color == .white) { origin = ChessBoardField.E1 }
            else if (piece.piece == .pawn && piece.color == .black) { origin = ChessBoardField.A7 }
            else if (piece.piece == .rook && piece.color == .black) { origin = ChessBoardField.A8 }
            else if (piece.piece == .knight && piece.color == .black) { origin = ChessBoardField.B8 }
            else if (piece.piece == .bishop && piece.color == .black) { origin = ChessBoardField.C8 }
            else if (piece.piece == .queen && piece.color == .black) { origin = ChessBoardField.D8 }
            else if (piece.piece == .king && piece.color == .black) { origin = ChessBoardField.E8 }
            else { print ("Error: Unknown piece")}
            
            if origin == nil { return }
            
            let translation = self.calculateTranslationForMove(from: origin!, to: piece.location)
            piece.entity.move(to: Transform(translation: translation), relativeTo: piece.entity, duration: 0.0)
        }
    }
    
    public func getModelEntity() -> Entity? { self.baseModel }
    public func isModelLoaded() -> Bool { self.baseModel != nil }
    public func areMeshesExtracted() -> Bool { self.meshCollection != nil }
    
    private func animateMovement(of piece: ChessPiece3D, to destination: ChessBoardField, duration: TimeInterval) {
        let translation = self.calculateTranslationForMove(from: piece.location, to: destination)
        
        piece.entity.move(to: Transform(translation: translation), relativeTo: piece.entity, duration: duration)
        
        let pieceInDestination = self.piecesOnBoard.first { piece in piece.location == destination }
        let uuid = pieceInDestination?.id
        
        if pieceInDestination != nil {
            // Perform the removal of the piece at the destination after a delay, ensuring main thread safety
            Timer.scheduledTimer(withTimeInterval: duration * 0.8, repeats: false) { [weak self] _ in
                Task { @MainActor in
                    // Remove the piece from the scene and board
                    let x = self?.piecesOnBoard.first { piece in piece.id == uuid }
                    x!.entity.removeFromParent()
                    if let index = self?.piecesOnBoard.firstIndex(where: { $0 === x }) {
                        self?.piecesOnBoard.remove(at: index)
                    }
                }
            }
        }
    }
    
    private func animateMovement(from origin: ChessBoardField, to destination: ChessBoardField, duration: TimeInterval) {
        let piece = self.piecesOnBoard.first { piece in piece.location == origin }
        if (piece == nil) { return }
        
        self.animateMovement(of: piece!, to: destination, duration: duration)
    }
    
    private func calculateTranslationForMove(from origin: ChessBoardField, to destination: ChessBoardField) -> SIMD3<Float> {
        let numRows = destination.rank - origin.rank
        let numCols = destination.file - origin.file

        let pieceOnBoard = self.piecesOnBoard.first(where: { piece in piece.location == origin })
        let distanceScalingFactor = pieceOnBoard!.entity.scale(relativeTo: self.boardEntity)
        
        let fieldWidth = self.boardBounds.width / 8
        var xDistance = Float(numCols) * fieldWidth * (1.0 / distanceScalingFactor.x)
        var zDistance = -Float(numRows) * fieldWidth * (1.0 / distanceScalingFactor.z)
        
        if ((pieceOnBoard?.piece == .bishop || pieceOnBoard?.piece == .knight) && pieceOnBoard?.color == .white) {
            xDistance *= -1
            zDistance *= -1
        }
        
        return SIMD3(xDistance, 0, zDistance)
    }
    
    private func extractMeshes() async throws {
        if (!self.isModelLoaded()) { return }
        
        // The asset (from https://fab.com) comes with a deeply nested hierarchy, so we need to
        // go 6 stages deep to be able to use the meshes for the pieces
        guard let meshCollection = self.baseModel?.children.first?.children.first?.children.first?.children.first?.children.first?.children
        else { fatalError("ChessBoard model has unexpected structure! Couldn't locate mesh collection.") }
        
        guard let boardMesh = meshCollection.first(where: { mesh in mesh.name == "Cube_001_32" })
        else { fatalError("Chessboard model has unexpected structure! Couldn't locate board cube mesh.") }
        
        guard let whiteSquaresEntity = boardMesh.children.first(where: { mesh in mesh.name == "Object_68" })
        else { fatalError("Chessboard model has unexpected structure! Couldn't locate white square entity.") }
        
        guard let blackSquaresEntity = boardMesh.children.first(where: { mesh in mesh.name == "Object_69" })
        else { fatalError("Chessboard model has unexpected structure! Couldn't locate black square entity.") }
        
        self.boardEntity = whiteSquaresEntity // We could choose either white or black squares entities for this, since both are squares with the same dimensions
        self.meshCollection = meshCollection
    }

    private func fillInventory() async throws {
        // Ensure that meshes are extracted before proceeding
        if (!self.areMeshesExtracted()) { return }
        
        // Initialize dictionaries to store meshes for each piece type
        var blackMeshes: [PieceType: Entity] = [:]
        var whiteMeshes: [PieceType: Entity] = [:]
        
        // Iterate through the mesh collection and assign meshes to the appropriate dictionaries
        self.meshCollection?.forEach { mesh in
            switch mesh.name {
            case "Cylinder_040_3":
                blackMeshes[.pawn] = mesh
            case "Cylinder_043_0":
                blackMeshes[.rook] = mesh
            case "Cylinder_042_1":
                blackMeshes[.knight] = mesh
            case "Cylinder_041_2":
                blackMeshes[.bishop] = mesh
            case "Cylinder_002_29":
                blackMeshes[.king] = mesh
            case "Cylinder_003_28":
                blackMeshes[.queen] = mesh
                
            case "Cylinder_033_10":
                whiteMeshes[.pawn] = mesh
            case "Cylinder_026_17":
                whiteMeshes[.rook] = mesh
            case "Cylinder_025_18":
                whiteMeshes[.knight] = mesh
            case "Cylinder_024_19":
                whiteMeshes[.bishop] = mesh
            case "Cylinder_008_23":
                whiteMeshes[.king] = mesh
            case "Cylinder_009_22":
                whiteMeshes[.queen] = mesh
                
            default:
                break
            }
        }
        
        self.inventory = PieceInventory(whiteModels: whiteMeshes, blackModels: blackMeshes)
    }

}
