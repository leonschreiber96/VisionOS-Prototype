//
//  Vision_OS_PrototypeApp.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 12.11.24.
//

import SwiftUI

@main
struct Vision_OS_PrototypeApp: App {

    private var appModel = AppModel()
    
    @State private var orbitImmersionStyle: ImmersionStyle = .mixed
    
    @UIApplicationDelegateAdaptor private var appDelegate: CustomApplicationDelegate

    var body: some Scene {
        WindowGroup {
            MainWindow(appModel: appModel)
                .frame(minWidth: 500, minHeight: 500)
        }
        .defaultSize(width: 1, height: 0.6, depth: 0.1, in: .meters)
        .windowResizability(.contentSize)
        .environment(appModel)
        
        
        WindowGroup(id: "multiview") {
            VideoHomeView(multiviewStateModel: .init(videos: defaultVideos))
                .onDisappear {
                    appModel.showingLiveStream = false
                }
                .onAppear {
                    appModel.showingLiveStream = true
                }
        }
        .windowResizability(.contentSize)
        .environment(appModel)
        
        ImmersiveSpace(id: "ChessBoard3DView"){
            Orbit()
                .environment(appModel)
        }
        .environment(appModel)
        .immersionStyle(selection: $orbitImmersionStyle, in: .mixed)
    }
}
