/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model content for the orbit module.
*/

import SwiftUI
import RealityKit

/// The model content for the orbit module.
struct ChessBoard3DView: View {
    @State private var chessBoard3DEntity: ChessBoardEntity?
//    let anchor = AnchorEntity(.head, trackingMode: .once)
    //private let boardDimensions: SIMD3<Float>
    
    var body: some View {
        RealityView { content in
            let chessBoard3DEntity = ChessBoardEntity()
            content.add(chessBoard3DEntity)

            Task {
                try await chessBoard3DEntity.setup()
                
                let collisionComponent = CollisionComponent(shapes: [ShapeResource.generateBox(width: 2.0, height: 2.0, depth: 0.02)])
                chessBoard3DEntity.components.set(collisionComponent)
                chessBoard3DEntity.components.set(InputTargetComponent())
                chessBoard3DEntity.generateCollisionShapes(recursive: true)
                
                chessBoard3DEntity.board!.initializePieces()
                
//                DispatchQueue.main.async {
//                    let moves = [
//                        "d2-d4", "d7-d5",
//                        "c2-c4", "b8-c6",
//                        "e2-e3", "c8-f5",
//                        "c4-d5", "c6-b4",
//                        "f1-d3", "b4-d3",
//                        "e1-e2", "d3-b4",
//                        "b1-c3", "b4-c2",
//                        "e2-d2", "c2-a1",
//                        "g1-f3", "f5-c2",
//                        "d2-e1", "c2-d1"
//                    ]
//                    
//                    var counter = 0
//                    
//                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
//                        let move = moves[counter]
//                        let origin = String(move.split(separator: "-").first!)
//                        let destination = String(move.split(separator: "-").last!)
//                        
//                        chessBoard3DEntity.board!.applyMove(from: ChessBoardField(rawValue: origin.uppercased())!, to: ChessBoardField(rawValue: destination.uppercased())!)
//                        counter += 1
//                    }
//                }
            }
        } update: { content in
            chessBoard3DEntity?.update(
                scale: SIMD3(repeating: 0.05), position: .zero
            )
        }
    }
}

#Preview { ChessBoard3DView() }
