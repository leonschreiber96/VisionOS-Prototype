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

            print(chessBoard3DEntity.children)
            print(chessBoard3DEntity.visualBounds(relativeTo: nil))

        } update: { content in
            print("Updating ChessBoard3D")
            chessBoard3DEntity?.update(
                scale: SIMD3(repeating: 0.05), position: .zero
            )
        }
    }
    
    private func createSphere(radius: Float, color: UIColor) -> ModelEntity {
            let sphereMesh = MeshResource.generateSphere(radius: radius)
            let material = SimpleMaterial(color: color, isMetallic: false)
            let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
            return sphereEntity
        }
}

#Preview { ChessBoard3D() }
