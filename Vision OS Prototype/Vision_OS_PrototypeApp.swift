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

    var body: some Scene {
        WindowGroup {
            ChessBoardView()
                .environment(appModel)
        }
     }
}
