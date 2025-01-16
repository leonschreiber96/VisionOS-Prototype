//
//  ChessBoardEntity.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//

import RealityKit
import SwiftUI
import RealityKitContent

enum ChessError: Error {
    case invalidPiece
    case invalidBoardIndex
}

enum PieceType: Int {
    case pawn = 0b001
    case rook = 0b010
    case knight = 0b011
    case bishop = 0b100
    case king = 0b101
    case queen = 0b110
}

enum PieceColor: Int {
    case white = 0b1000
    case black = 0b0000
}

enum PieceMesh: String {
    case blackPawn = "Cylinder_040_3"
    case blackRook = "Cylinder_043_3"
    case blackKnight = "Cylinder_042_1"
    case blackBishop = "Cylinder_041_2"
    case blackKing = "Cylinder_002_29"
    case blackQueen = "Cylinder_003_28"
    case whitePawn = "Cylinder_033_10"
    case whiteRook = "Cylinder_026_17"
    case whiteKnight = "Cylinder_025_18"
    case whiteBishop = "Cylinder_024_19"
    case whiteKing = "Cylinder_008_23"
    case whiteQueen = "Cylinder_009_22"
}

struct PieceOnBoard {
    public let piece: PieceType
    public let color: PieceColor
    public let locationString: String
    public let locationIndex: Int
    public let meshName: PieceMesh
    public let entity: Entity
}

class ChessBoardEntity : Entity {
    // MARK: - Internal State
    let boardState: BoardState = .init(fen: "rnbqkbnr/ppppp1pp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    let game: ChessGame = ChessGame()
    
    var piecesOnBoard: [PieceOnBoard] = []
    var pieceInventory: [PieceMesh: Entity] = [:]
    
    public var chessBoardEntity: Entity?
    public var piecesMeshCollection: ChildCollection?
    
    public var whiteSquaresEntity: Entity?
    public var blackSquaresEntity: Entity?

    public var boardBounds: (width: Float, height: Float, depth: Float) = (width: 0.0, height: 0.0, depth: 0.0)
    
    private var piecesByLocation: [String: Entity] = [:]
//    private var pieceMeshes: [Int: Entity] = [:]
    
    private let pieceMeshNames: [Int: String] = [
        0b0001: "Cylinder_040_3",  // Black pawn
        0b0010: "Cylinder_043_0",  // Black rook
        0b0011: "Cylinder_042_1",  // Black knight
        0b0100: "Cylinder_041_2",  // Black bishop
        0b0101: "Cylinder_002_29", // Black king
        0b0110: "Cylinder_003_28", // Black queen

        0b1001: "Cylinder_033_10", // White pawn
        0b1010: "Cylinder_026_17", // White rook
        0b1011: "Cylinder_025_18", // White knight
        0b1100: "Cylinder_024_19", // White bishop
        0b1101: "Cylinder_008_23", // White king
        0b1110: "Cylinder_009_22"  // White queen
    ]
    
    @MainActor required init () {
        super.init()
    }
    
    @MainActor public func setup() async {
        guard let chessBoard = await RealityKitContent.entity(named: "ChessBoard") else {
            fatalError("Could not load chess board asset!")
        }
        
        self.children.append(chessBoard)
        
        // The asset (from https://fab.com) comes with a deeply nested hierarchy, so we need to
        // go 6 stages deep to be able to use the meshes for the pieces
        self.piecesMeshCollection = chessBoard.children[0].children[0].children[0].children[0].children[0].children
        
        let boardCube = piecesMeshCollection?.first(where: { $0.name == "Cube_001_32" })
        self.whiteSquaresEntity = boardCube?.children.first(where: { $0.name == "Object_68" })
        self.blackSquaresEntity = boardCube?.children.first(where: { $0.name == "Object_69" })
        self.chessBoardEntity = boardCube
        
        self.updateBounds()
        
        self.piecesMeshCollection?.forEach {
            if ($0.name.starts(with: "Cylinder")) {
                guard let meshName = originalToUnifiedMeshName(meshName: $0.name) else {
                    print("Error: Unknown mesh name \($0.name)")
                    return
                }
                                
                if (self.pieceInventory[meshName] == nil) {
                    self.pieceInventory[meshName] = $0.clone(recursive: true)
                }
                // TODO: find out how to dispose original entity
            }
        }
        
        self.piecesMeshCollection?.removeAll(where: { $0.name.starts(with: "Cylinder") })
        
        self.piecesOnBoard = [
            // White pieces
            .init(piece: .rook,   color: .white, locationString: "a1", locationIndex: 0,  meshName: .whiteRook,   entity: self.pieceInventory[.whiteRook]!.clone(recursive: true)),
            .init(piece: .knight, color: .white, locationString: "b1", locationIndex: 1,  meshName: .whiteKnight, entity: self.pieceInventory[.whiteKnight]!.clone(recursive: true)),
            .init(piece: .bishop, color: .white, locationString: "c1", locationIndex: 2,  meshName: .whiteBishop, entity: self.pieceInventory[.whiteBishop]!.clone(recursive: true)),
            .init(piece: .queen,  color: .white, locationString: "d1", locationIndex: 3,  meshName: .whiteQueen,  entity: self.pieceInventory[.whiteQueen]!.clone(recursive: true)),
            .init(piece: .king,   color: .white, locationString: "e1", locationIndex: 4,  meshName: .whiteKing,   entity: self.pieceInventory[.whiteKing]!.clone(recursive: true)),
            .init(piece: .bishop, color: .white, locationString: "f1", locationIndex: 5,  meshName: .whiteBishop, entity: self.pieceInventory[.whiteBishop]!.clone(recursive: true)),
            .init(piece: .knight, color: .white, locationString: "g1", locationIndex: 6,  meshName: .whiteKnight, entity: self.pieceInventory[.whiteKnight]!.clone(recursive: true)),
            .init(piece: .rook,   color: .white, locationString: "h1", locationIndex: 7,  meshName: .whiteRook,   entity: self.pieceInventory[.whiteRook]!.clone(recursive: true)),

            .init(piece: .pawn,   color: .white, locationString: "a2", locationIndex: 8,  meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "b2", locationIndex: 9,  meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "c2", locationIndex: 10, meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "d2", locationIndex: 11, meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "e2", locationIndex: 12, meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "f2", locationIndex: 13, meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "g2", locationIndex: 14, meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .white, locationString: "h2", locationIndex: 15, meshName: .whitePawn,   entity: self.pieceInventory[.whitePawn]!.clone(recursive: true)),

            // Black pieces
            .init(piece: .rook,   color: .black, locationString: "a8", locationIndex: 56, meshName: .blackRook,   entity: self.pieceInventory[.blackRook]!.clone(recursive: true)),
            .init(piece: .knight, color: .black, locationString: "b8", locationIndex: 57, meshName: .blackKnight, entity: self.pieceInventory[.blackKnight]!.clone(recursive: true)),
            .init(piece: .bishop, color: .black, locationString: "c8", locationIndex: 58, meshName: .blackBishop, entity: self.pieceInventory[.blackBishop]!.clone(recursive: true)),
            .init(piece: .queen,  color: .black, locationString: "d8", locationIndex: 59, meshName: .blackQueen,  entity: self.pieceInventory[.blackQueen]!.clone(recursive: true)),
            .init(piece: .king,   color: .black, locationString: "e8", locationIndex: 60, meshName: .blackKing,   entity: self.pieceInventory[.blackKing]!.clone(recursive: true)),
            .init(piece: .bishop, color: .black, locationString: "f8", locationIndex: 61, meshName: .blackBishop, entity: self.pieceInventory[.blackBishop]!.clone(recursive: true)),
            .init(piece: .knight, color: .black, locationString: "g8", locationIndex: 62, meshName: .blackKnight, entity: self.pieceInventory[.blackKnight]!.clone(recursive: true)),
            .init(piece: .rook,   color: .black, locationString: "h8", locationIndex: 63, meshName: .blackRook,   entity: self.pieceInventory[.blackRook]!.clone(recursive: true)),

            .init(piece: .pawn,   color: .black, locationString: "a7", locationIndex: 48, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "b7", locationIndex: 49, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "c7", locationIndex: 50, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "d7", locationIndex: 51, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "e7", locationIndex: 52, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "f7", locationIndex: 53, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "g7", locationIndex: 54, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true)),
            .init(piece: .pawn,   color: .black, locationString: "h7", locationIndex: 55, meshName: .blackPawn,   entity: self.pieceInventory[.blackPawn]!.clone(recursive: true))
        ]
        
        self.piecesOnBoard.forEach {piece in
            
//            let piece = $0
//            print(calculateTranslationForMove(from: 0, to: piece.locationIndex))
////            piece.entity.setPosition(SIMD3(self.boardBounds.width / 2 * Float.random(in: -1.0...1.0), self.position.y, self.boardBounds.depth / 2 * Float.random(in: -1.0...1.0)), relativeTo: self.whiteSquaresEntity)
//            self.piecesMeshCollection?.append(piece.entity)
//            let translation = calculateTranslationForMove(from: 0, to: piece.locationIndex)
//            print(translation)
//            piece.entity.move(to: Transform(translation: translation), relativeTo: piece.entity, duration: 1.0)
            let row = piece.locationIndex / 8
            let col = piece.locationIndex % 8
            let fieldWidth = Float(self.boardBounds.width) / 8.0
            self.piecesMeshCollection?.append(piece.entity)
        }
        
//        self.piecesMeshCollection?.forEach {
//            let pieceEntity = $0
//            
//            if (!pieceEntity.name.starts(with: "Cylinder")) {
//                return
//            }
//            
//            let name = originalToUnifiedMeshName(entityName: pieceEntity.name)!
//            self.piecesByLocation[name] = pieceEntity
//        }
//        
//        for (numeric, name) in self.pieceMeshNames {
//            let entity = self.piecesMeshCollection?.first(where: { $0.name == name })
//            self.pieceMeshes[numeric] = entity
//        }
//        
//        
//        
//        if (self.piecesMeshCollection == nil) {
//            fatalError( "Could not load chess piece meshes!")
//        }
//        
        update(scale: SIMD3(repeating: 0.04), position: .zero)
        
        // boardState.displayBoard()
    }
    
    public func applyMove(from origin: String, to destination: String, duration: TimeInterval = 2.0) {
        let originIndex: Int = self.game.board.getInternalIndex(for: origin)
        let destinationIndex: Int = self.game.board.getInternalIndex(for: destination)
        
        let translation = self.calculateTranslationForMove(from: originIndex, to: destinationIndex)
        
        let pieceOnBoard = self.piecesOnBoard.first { $0.locationIndex == originIndex }
        
        pieceOnBoard!.entity.move(to: Transform(translation: translation), relativeTo: pieceOnBoard!.entity, duration: duration)
    }
    
    public func moveEntity(which entity: Entity, from origin: String, to destination: String) {
        let originIndex: Int = self.game.board.getInternalIndex(for: origin)
        let destinationIndex: Int = self.game.board.getInternalIndex(for: destination)
        
        let translation = self.calculateTranslationForMove(from: originIndex, to: destinationIndex)
        
        print(translation)
        print(entity.name, entity.position)
        entity.move(to: Transform(translation: translation), relativeTo: entity, duration: 1.0)
    }
    
//    public func addPiece(at location: String, which piece: PieceType, whose color: PieceColor) {
//        let piece = piece.rawValue | color.rawValue
//        let entity = self.createNewPieceEntity(piece: piece)
//        let locationIndex = self.game.board.getInternalIndex(for: location)
//        
//        entity.move(to: calculateTranslationForMove(from: 0, to: locationIndex, with: piece), relativeTo: entity, duration: 0)
//        
//        self.piecesMeshCollection!.append(entity)
//    }
//    
//    private func createNewPieceEntity(piece: Int) -> Entity {
//        let entity = self.pieceMeshes[piece]?.clone(recursive: true)
//        return entity!
//    }
    
    private func updateBounds() {
        let newBounds = self.whiteSquaresEntity!.visualBounds(relativeTo: self.whiteSquaresEntity)

        let min = newBounds.min
        let max = newBounds.max

        let width = max.x - min.x
        let height = max.y - min.y
        let depth = max.z - min.z
        
        self.boardBounds = (width: width, height: height, depth: depth)
    }
    
    private func calculateTranslationForMove(from origin: Int, to destination: Int) -> SIMD3<Float> {
        let originRow = origin / 8
        let originCol = origin % 8
        let destinationRow = destination / 8
        let destinationCol = destination % 8
        
        let numRows = destinationRow - originRow
        let numCols = destinationCol - originCol
        
//        print(numRows, numCols)
        
        let fieldWidth = self.boardBounds.width / 8
        
        let pieceOnBoard = self.piecesOnBoard.first(where: { $0.locationIndex == origin })
        
        let distanceScalingFactor = pieceOnBoard?.entity.scale(relativeTo: self.chessBoardEntity)
        
//        print(fieldWidth, distanceScalingFactor)
        
        let xDistance = Float(numCols) * fieldWidth * (1.0 / distanceScalingFactor!.x)
        let zDistance = -Float(numRows) * fieldWidth * (1.0 / distanceScalingFactor!.z)
        
        return SIMD3(xDistance, 0, zDistance)
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
//                rotation: .init(angle: 0.2, axis: [0, 1, 0]),
                translation: position
            ),
            relativeTo: parent)
        
        self.updateBounds();
    }

    
    func originalToUnifiedMeshName(meshName: String) -> PieceMesh? {
        let mapping: [String: PieceMesh] = [
            "Cylinder_043_0": PieceMesh.blackRook,
            "Cylinder_042_1": PieceMesh.blackKnight,
            "Cylinder_041_2": PieceMesh.blackBishop,
            "Cylinder_003_28": PieceMesh.blackQueen,
            "Cylinder_002_29": PieceMesh.blackKing,
            "Cylinder_004_27": PieceMesh.blackBishop,
            "Cylinder_005_26": PieceMesh.blackKnight,
            "Cylinder_001_30": PieceMesh.blackRook,
            
            "Cylinder_040_3": PieceMesh.blackPawn,
            "Cylinder_039_4": PieceMesh.blackPawn,
            "Cylinder_038_5": PieceMesh.blackPawn,
            "Cylinder_037_6": PieceMesh.blackPawn,
            "Cylinder_036_7": PieceMesh.blackPawn,
            "Cylinder_035_8": PieceMesh.blackPawn,
            "Cylinder_034_9": PieceMesh.blackPawn,
            "Cylinder_31": PieceMesh.blackPawn,
            
            "Cylinder_033_10": PieceMesh.whitePawn,
            "Cylinder_032_11": PieceMesh.whitePawn,
            "Cylinder_031_12": PieceMesh.whitePawn,
            "Cylinder_030_13": PieceMesh.whitePawn,
            "Cylinder_029_14": PieceMesh.whitePawn,
            "Cylinder_028_15": PieceMesh.whitePawn,
            "Cylinder_027_16": PieceMesh.whitePawn,
            "Cylinder_006_25": PieceMesh.whitePawn,
            
            "Cylinder_026_17": PieceMesh.whiteRook,
            "Cylinder_025_18": PieceMesh.whiteKnight,
            "Cylinder_024_19": PieceMesh.whiteBishop,
            "Cylinder_009_22": PieceMesh.whiteQueen,
            "Cylinder_008_23": PieceMesh.whiteKing,
            "Cylinder_010_21": PieceMesh.whiteBishop,
            "Cylinder_011_20": PieceMesh.whiteKnight,
            "Cylinder_007_24": PieceMesh.whiteRook,
        ]
        
        return mapping[meshName]
    }
}

import Foundation

struct ChessMove {
    let from: String // e.g., "e2"
    let to: String   // e.g., "e4"
}

class BoardState {
    private var board: [String: ChessPiece] = [:]
    private var currentTurn: String = "w"
    
    init(fen: String) {
        parseFEN(fen: fen)
    }
    
    func piece(at position: String) -> ChessPiece? {
        return board[position]
    }
    
    func makeMove(_ move: ChessMove, color: String) -> Bool {
        guard currentTurn == color else {
            print("It's not \(color)'s turn!")
            return false
        }
        
        guard let piece = board[move.from] else {
            print("No piece at \(move.from)")
            return false
        }
        
        guard piece.color == color else {
            print("The piece at \(move.from) does not belong to \(color)")
            return false
        }
        
        // Assume all moves are valid for simplicity (you can add validation)
        board[move.to] = piece
        board[move.from] = nil
        currentTurn = color == "w" ? "b" : "w"
        return true
    }
    
    func displayBoard() {
        let ranks = (1...8).reversed()
        let files = "abcdefgh"
        for rank in ranks {
            var line = ""
            for file in files {
                let position = "\(file)\(rank)"
                if let piece = board[position] {
                    line += piece.color == "w" ? piece.type.uppercased() : piece.type.lowercased()
                } else {
                    line += "."
                }
                line += " "
            }
            print(line)
        }
    }
    
    private func parseFEN(fen: String) {
        let parts = fen.split(separator: " ")
        guard parts.count >= 2 else {
            fatalError("Invalid FEN string")
        }
        
        let piecePlacement = parts[0]
        let activeColor = parts[1]
        
        board = [:]
        currentTurn = activeColor == "w" ? "w" : "b"
        
        let ranks = piecePlacement.split(separator: "/")
        guard ranks.count == 8 else {
            fatalError("Invalid FEN string")
        }
        
        for (rankIndex, rank) in ranks.enumerated() {
            let rankNumber = 8 - rankIndex
            var fileIndex = 0
            
            for char in rank {
                if let emptySquares = char.wholeNumberValue {
                    fileIndex += emptySquares
                } else {
                    // Use String.Index to subscript a string
                    let file = "abcdefgh".index("abcdefgh".startIndex, offsetBy: fileIndex)
                    let position = "\(String("abcdefgh"[file]))\(rankNumber)"
                    let color: String = char.isUppercase ? "w" : "b"
                    let pieceType = char.uppercased()
                    board[position] = ChessPiece(type: pieceType, color: color)
                    fileIndex += 1
                }
            }
        }
    }
}
