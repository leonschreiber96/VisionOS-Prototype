/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model content for the orbit module.
*/

import SwiftUI
import RealityKit

/// The model content for the orbit module.
struct ChessBoard3D: View {
    @State private var chessBoard3DEntity: ChessBoardEntity?
//    let anchor = AnchorEntity(.head, trackingMode: .once)
    //private let boardDimensions: SIMD3<Float>
    
    var body: some View {
        RealityView { content in
            let chessBoard3DEntity = ChessBoardEntity()
            content.add(chessBoard3DEntity)

            Task {
                await chessBoard3DEntity.setup()
                
                let collisionComponent = CollisionComponent(shapes: [ShapeResource.generateBox(width: 2.0, height: 2.0, depth: 0.02)])
                chessBoard3DEntity.components.set(collisionComponent)
                chessBoard3DEntity.components.set(InputTargetComponent())
                chessBoard3DEntity.generateCollisionShapes(recursive: true)
                
                DispatchQueue.main.async {
                    chessBoard3DEntity.piecesOnBoard.forEach { piece in
                        var origin: String = ""
                        if (piece.piece == .pawn && piece.color == .white) { origin = "a2" }
                        else if (piece.piece == .rook && piece.color == .white) { origin = "a1" }
                        else if (piece.piece == .knight && piece.color == .white) { origin = "b1" }
                        else if (piece.piece == .bishop && piece.color == .white) { origin = "c1" }
                        else if (piece.piece == .queen && piece.color == .white) { origin = "d1" }
                        else if (piece.piece == .king && piece.color == .white) { origin = "e1" }
                        else if (piece.piece == .pawn && piece.color == .black) { origin = "a7" }
                        else if (piece.piece == .rook && piece.color == .black) { origin = "a8" }
                        else if (piece.piece == .knight && piece.color == .black) { origin = "b8" }
                        else if (piece.piece == .bishop && piece.color == .black) { origin = "c8" }
                        else if (piece.piece == .queen && piece.color == .black) { origin = "d8" }
                        else if (piece.piece == .king && piece.color == .black) { origin = "e8" }
                        else { print ("Error: Unknown piece")}
                        
                        print(piece.piece, piece.color, origin, piece.locationString)
                        chessBoard3DEntity.moveEntity(which: piece.entity, from: origin, to: piece.locationString)
                        print("\n")
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                        
                    }

                }
            }
        } update: { content in
            chessBoard3DEntity?.update(
                scale: SIMD3(repeating: 0.05), position: .zero
            )
        }
    }
}

#Preview { ChessBoard3D() }
