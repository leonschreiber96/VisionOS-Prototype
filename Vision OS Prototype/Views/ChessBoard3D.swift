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
    
    var body: some View {
        RealityView { content in
            let chessBoard3DEntity = await ChessBoardEntity(testBool: true)

            content.add(chessBoard3DEntity)
            let collisionComponent = CollisionComponent(shapes: [ShapeResource.generateBox(width: 2.0, height: 2.0, depth: 0.02)])
            chessBoard3DEntity.components.set(collisionComponent)
            chessBoard3DEntity.components.set(InputTargetComponent())
            chessBoard3DEntity.generateCollisionShapes(recursive: true)

            let pieces = chessBoard3DEntity.children[0].children[0].children[0]
                .children[0].children[0].children[0]
            
            var counter = 0
            
            let rook = pieces.children[0].clone(recursive: true)
            
            pieces.children.forEach { piece in
                if (counter < 5) {
                    piece.removeFromParent()
                }
                counter += 1
            }
            
            pieces.addChild(rook)
            
//            pieces.children[0].transform.translation += SIMD3<Float>(repeating: 0.5)
            
//            translateMesh(entity: chessBoard3DEntity, meshName: "Cylinder_043_0", translation: SIMD3<Float>(repeating: 0.5))

        } update: { content in
            chessBoard3DEntity?.update(
                scale: SIMD3(repeating: 0.05), position: .zero
            )
        }
    }
}

#Preview { ChessBoard3D() }
