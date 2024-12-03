//
//  ChessWindowEntity.swift
//  ChessXR
//
//  Created by Albnor Sahiti on 16.11.24.
//

import RealityKit
import SwiftUI

class ChessWindowEntity: Entity, HasAnchoring {
    required init() {
        super.init()
        setupChessWindow()
    }

    private func setupChessWindow() {
        // Erstelle die SwiftUI-Ansicht
        let chessView = ChessGameView()
        let hostingController = UIHostingController(rootView: chessView)

        // Konvertiere die SwiftUI-Ansicht in ein UIImage
        let view = hostingController.view!
        view.bounds = CGRect(x: 0, y: 0, width: 1024, height: 1024) // Größere Bounds
        print("SwiftUI View Bounds: \(view.bounds)")

        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        // Speichere das UIImage zur Überprüfung
        if let data = image.pngData() {
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("chessView.png")
            try? data.write(to: fileURL)
            print("Image gespeichert unter: \(fileURL.path)")
        }

        // Konvertiere UIImage in CGImage
        guard let cgImage = image.cgImage else {
            print("Fehler: Konnte UIImage nicht in CGImage konvertieren.")
            return
        }

        // Lade die Textur mit Optionen
        let textureOptions = TextureResource.CreateOptions(semantic: .none)
        guard let texture = try? TextureResource.generate(from: cgImage, options: textureOptions) else {
            print("Fehler: Konnte CGImage nicht in TextureResource konvertieren.")
            return
        }
        print("Textur erfolgreich erstellt")

        // Erstelle das PhysicallyBasedMaterial und weise die Textur zu
        var material = PhysicallyBasedMaterial()
        material.baseColor.texture = MaterialParameters.Texture(texture)

        // Erstelle eine Plane (Fenster) und wende das Material an
        let plane = MeshResource.generatePlane(width: 0.5, height: 0.5) // 0.5m x 0.5m Fenster
        let modelEntity = ModelEntity(mesh: plane, materials: [material])
        self.addChild(modelEntity)
    }
}

