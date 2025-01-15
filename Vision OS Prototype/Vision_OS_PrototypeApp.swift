//
//  Vision_OS_PrototypeApp.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 12.11.24.
//

import SwiftUI

@main
struct Vision_OS_PrototypeApp: App {

    @State private var appModel = AppModel()
    
    @State private var orbitImmersionStyle: ImmersionStyle = .mixed

    var body: some Scene {
//        WindowGroup {
//            InitialView()
//                .environment(appModel)
//        }
        
        WindowGroup {
            ChessGameView()
                .environment(appModel)
        }
        
        WindowGroup(id: "livestream-window") {
            VideoView()
                .environment(appModel)
        }
        
        ImmersiveSpace(id: "ChessBoard3D"){
            Orbit()
                .environment(appModel)
        }
        .immersionStyle(selection: $orbitImmersionStyle, in: .mixed)
    }
}
