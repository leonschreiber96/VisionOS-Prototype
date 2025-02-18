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
    private var streamObject: ChessEventStream
    
    private var baseModel: Entity?
    private var meshCollection: Entity.ChildCollection?
    private var boardEntity: Entity?
    
    private var inventory: PieceInventory?
    
    public var piecesOnBoard: [ChessPiece3D] = []
    
    private var boardBounds: (width: Float, height: Float, depth: Float) = (width: 0.0, height: 0.0, depth: 0.0)
    
    init(realityKitModelIdentifier: String?, stream: ChessEventStream) {
        if (realityKitModelIdentifier != nil) { self.realityKitModelIdentifier = realityKitModelIdentifier! }
        self.streamObject = stream
        
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
        
        let x = ChessBoard()
        x.getAllPieces()
            .forEach { piece in
                let mesh = self.inventory!.getModel(color: piece.color, type: piece.type)
                self.meshCollection!.append(mesh)
                self.piecesOnBoard.append(ChessPiece3D(piece: piece.type, color: piece.color, location: piece.position, entity: mesh))
            }
        
        let newBounds: BoundingBox = self.boardEntity!.visualBounds(relativeTo: self.boardEntity)
        
        let min: SIMD3<Float> = newBounds.min
        let max: SIMD3<Float> = newBounds.max

        let width: Float = max.x - min.x
        let height: Float = max.y - min.y
        let depth: Float = max.z - min.z
        
        self.boardBounds = (width: width, height: height, depth: depth)
        
        GameStateChangedNotificationCenter.shared.registerMoveHandler(eventGuid: self.streamObject.eventObject.guid, observer: { move in
            print("registered move in 3D board")
            self.applyMove(move: move, duration: 1.0)
        })
    }
    
    /**
     Applies a move to the 3D chess board and updates internal state accordingly.
     
     Steps that happen:
        1. Animate the movement of the visible piece meshes involved (also remove captured pieces if applicable)
        2. Modify the internal state of the chess game
        3. Modify the internal representation of where the pieces are located
     */
    public func applyMove(move: ChessMove, duration: TimeInterval = 2.0) {
        self.animateMovement(move: move, duration: duration)
//        self.gameObject.addMove(from: origin, to: destination)
        
        let piece3D = self.piecesOnBoard.first { piece in piece.location == move.origin }!
        piece3D.location = move.target
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

            let translation = self.calculateTranslationForMove(move: ChessMove(from: origin!, to: piece.location, which: (type: piece.piece, color: piece.color)))
            piece.entity.move(to: Transform(translation: translation), relativeTo: piece.entity, duration: 0.0)
        }
        
        DispatchQueue.main.async {
//                            let moves = [
//                                ChessMove(from: .H2, to: .H6, which: (type: .pawn, color: .white)),
//                                ChessMove(from: .H6, to: .A6, which: (type: .pawn, color: .white))
//                            ]
            
            let moves = self.streamObject.movesUntilCurrentTimestamp
        
                            var counter = 0
        
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                    if (counter >= moves.count) {
                        return}
                    let move = moves[counter]
            
                    let translation = self.calculateTranslationForMove(move: move)
                    let piece3D = self.piecesOnBoard.first { piece in piece.location == move.origin }!
                    piece3D.entity.move(to: Transform(translation: translation), relativeTo: piece3D.entity)
                
                let pieceInDestination = self.piecesOnBoard.first { piece in piece.location == move.target }
                            let uuid = pieceInDestination?.id
                if pieceInDestination != nil {
                                        let x = self.piecesOnBoard.first { piece in piece.id == uuid }
                                        x!.entity.removeFromParent()
                                        if let index = self.piecesOnBoard.firstIndex(where: { $0 === x }) {
                                            self.piecesOnBoard.remove(at: index)
                                        }
                            }
                piece3D.location = move.target
                    if move.isCastlingMove {
                        let possibleRookOrigins: [ChessBoardField] = move.movedPiece.color == .white ? [.A1, .H1] : [.A8, .H8]
                        let possibleRookDestinations: [ChessBoardField] = move.movedPiece.color == .white ? [.C1, .F1] : [.C8, .F8]
                        let correspondingRookOrigin = move.target.file > 4 ? possibleRookOrigins[1] : possibleRookOrigins[0]
                        let correspondingRookTarget = move.target.file > 4 ? possibleRookDestinations[1] : possibleRookDestinations[0]
                        let rookMove = ChessMove(from:correspondingRookOrigin, to: correspondingRookTarget, which: (type: .rook, color: move.movedPiece.color))
                        let rookTranslation = self.calculateTranslationForMove(move: rookMove)
                        let rookPiece3D = self.piecesOnBoard.first { piece in piece.location == rookMove.origin }!
                        rookPiece3D.entity.move(to: Transform(translation: rookTranslation), relativeTo: rookPiece3D.entity)
                        rookPiece3D.location = rookMove.target
                    }
                    counter += 1
                }
            }
        
//        let moves = self.gameObject.moveHistory
//        moves.forEach { move in
//            let translation = self.calculateTranslationForMove(move: move)
//            let piece3D = self.piecesOnBoard.first { piece in piece.location == move.origin }!
//            piece3D.entity.move(to: Transform(translation: translation), relativeTo: piece3D.entity)
//            
//            if move.isCastlingMove {
//                let possibleRookOrigins: [ChessBoardField] = move.movedPiece.color == .white ? [.A1, .H1] : [.A8, .H8]
//                let possibleRookDestinations: [ChessBoardField] = move.movedPiece.color == .white ? [.C1, .F1] : [.C8, .F8]
//                let correspondingRookOrigin = move.target.file > 4 ? possibleRookOrigins[1] : possibleRookOrigins[0]
//                let correspondingRookTarget = move.target.file > 4 ? possibleRookDestinations[1] : possibleRookDestinations[0]
//                let rookMove = ChessMove(from:correspondingRookOrigin, to: correspondingRookTarget, which: (type: .rook, color: move.movedPiece.color))
//                let rookTranslation = self.calculateTranslationForMove(move: rookMove)
//                let rookPiece3D = self.piecesOnBoard.first { piece in piece.location == rookMove.origin }!
//                rookPiece3D.entity.move(to: Transform(translation: rookTranslation), relativeTo: rookPiece3D.entity)
//                rookPiece3D.location = rookMove.target
//            }
//            
//            let pieceInDestination = self.piecesOnBoard.first { piece in piece.location == move.target }
//            let uuid = pieceInDestination?.id
//            
//            if pieceInDestination != nil {
//                // Perform the removal of the piece at the destination after a delay, ensuring main thread safety
//    //            Timer.scheduledTimer(withTimeInterval: duration * 0.8, repeats: false) { [weak self] _ in
//    //                Task { @MainActor in
//                        // Remove the piece from the scene and board
//                        let x = self.piecesOnBoard.first { piece in piece.id == uuid }
//                        x!.entity.removeFromParent()
//                        if let index = self.piecesOnBoard.firstIndex(where: { $0 === x }) {
//                            self.piecesOnBoard.remove(at: index)
//                        }
//    //                }
//    //            }
//            }
//            piece3D.location = move.target
//        }
        
        print("Initialized")
    }
    
    public func getModelEntity() -> Entity? { self.baseModel }
    public func isModelLoaded() -> Bool { self.baseModel != nil }
    public func areMeshesExtracted() -> Bool { self.meshCollection != nil }
    
    private func animateMovement(move: ChessMove, duration: TimeInterval) {
        guard let piece = self.piecesOnBoard.first(where: { $0.location == move.origin })
        else { return }
        
        let translation = self.calculateTranslationForMove(move: move)
        
        piece.entity.move(to: Transform(translation: translation), relativeTo: piece.entity, duration: duration)
        
        let pieceInDestination = self.piecesOnBoard.first { piece in piece.location == move.target }
        let uuid = pieceInDestination?.id
        
        if pieceInDestination != nil {
            // Perform the removal of the piece at the destination after a delay, ensuring main thread safety
//            Timer.scheduledTimer(withTimeInterval: duration * 0.8, repeats: false) { [weak self] _ in
//                Task { @MainActor in
                    // Remove the piece from the scene and board
                    let x = self.piecesOnBoard.first { piece in piece.id == uuid }
                    x!.entity.removeFromParent()
                    if let index = self.piecesOnBoard.firstIndex(where: { $0 === x }) {
                        self.piecesOnBoard.remove(at: index)
                    }
//                }
//            }
        }
    }
    
//    private func animateMovement(move: ChessMove, duration: TimeInterval) {
//        let piece = self.piecesOnBoard.first { piece in piece.location == move.origin }
//        if (piece == nil) { return }
//        
//        self.animateMovement(move: move, duration: duration)
//    }
    
    private func calculateTranslationForMove(move: ChessMove) -> SIMD3<Float> {
        let origin = move.origin
        let destination = move.target
        
        let numRows = destination.rank - origin.rank
        let numCols = destination.file - origin.file

        let pieceOnBoard = self.piecesOnBoard.first(where: { piece in piece.location == origin })
        var distanceScalingFactor: SIMD3<Float>
        switch pieceOnBoard?.piece {
        case .queen, .king, .rook, .pawn:
            distanceScalingFactor = SIMD3<Float>(0.061787121, 0.954118609, 0.061787121)
        case .knight:
            distanceScalingFactor = SIMD3<Float>(0.0511548445, 0.789934754, 0.0511548519)
        case .bishop:
            distanceScalingFactor = SIMD3<Float>(0.0476998799, 0.736583054, 0.0476998873)
        default:
            distanceScalingFactor = SIMD3<Float>(0.061787121, 0.954118609, 0.061787121)
        }
        
        let fieldWidth = self.boardBounds.width / 8
        var xDistance = Float(numCols) * fieldWidth * (1.0 / distanceScalingFactor.x)
        var zDistance = -Float(numRows) * fieldWidth * (1.0 / distanceScalingFactor.z)
        
        if ((pieceOnBoard?.piece == .bishop || pieceOnBoard?.piece == .knight) && pieceOnBoard?.color == .white) {
            xDistance *= -1
            zDistance *= -1
        }
        
        if pieceOnBoard?.piece == .queen && pieceOnBoard?.color == .white {
            xDistance *= -1
        }
        
        if pieceOnBoard?.piece == .queen && pieceOnBoard?.color == .black {
            xDistance *= -1
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
