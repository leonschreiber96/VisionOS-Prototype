//
//  ChessBoardView.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//
import SwiftUI
import RealityKit

struct Orbit: View {
    var body: some View {
        ChessBoard3DView()
            .placementGestures(initialPosition: Point3D([475, -1200.0, -1200.0]))
    }
}

#Preview {
    Orbit()
}
