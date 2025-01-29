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
        WindowGroup {
            MainWindow(appModel: appModel)
                .environment(appModel)
                .frame(minWidth: 1360, minHeight: 765)
        }
        .defaultSize(width: 1.5, height: 1, depth: 0.1, in: .meters)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "livestream-window") {
            VideoView()
                .environment(appModel)
        }
        
        ImmersiveSpace(id: "ChessBoard3DView"){
            Orbit()
                .environment(appModel)
        }
        .immersionStyle(selection: $orbitImmersionStyle, in: .mixed)
    }
}
