//
//  ChessBoardView.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//
import SwiftUI
import RealityKit

struct ChessBoardView: View {
    var body: some View {
        RealityView { content in
            let entity = await ChessBoardEntity(testBool: true)
            content.add(entity)
        }
    }
}

#Preview {
    ChessBoardView()
}
