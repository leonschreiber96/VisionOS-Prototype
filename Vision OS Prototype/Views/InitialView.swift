//
//  ChessBoardView.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.11.24.
//
import SwiftUI
import RealityKit

struct InitialView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var isImmersiveSpaceOpen = false
    
    var body: some View {
        VStack {
            Text("Hello World")
            Button(isImmersiveSpaceOpen ? "Stop" : "Start") {
                Task {
                    if isImmersiveSpaceOpen {
                        await dismissImmersiveSpace()
                    } else {
                        await openImmersiveSpace(id: "ChessBoard3DView")
                    }
                    isImmersiveSpaceOpen.toggle()
                }
            }
        }
    }
}

#Preview {
    Orbit()
}
