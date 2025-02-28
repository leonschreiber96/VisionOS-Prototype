//
//  ChessGame2DView.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.01.25.
//

import SwiftUI

struct ChessBoard2DView: View {
    @ObservedObject public var viewModel: ChessBoard2DViewModel
    
    var body: some View {
        Canvas { context, size in
            let squareSize = size.height / 8  // Each square is 1/8 of the board
            
            for rank in 0..<8 {
                for file in 0..<8 {
                    let isLightSquare = (rank + file) % 2 == 0
                    var color = isLightSquare ? Color.white : Color.brown
                    
                    if (viewModel.highlightFields.first(where: { $0.file == file && $0.rank == rank })) != nil {
                        color = isLightSquare ? Color(red: 0.69, green: 0.63, blue: 0.20) : Color(red: 0.54, green: 0.48, blue: 0.14)
                    }
                    
                    let rect = CGRect(
                        x: CGFloat(file) * squareSize,
                        y: size.width - CGFloat(rank) * squareSize - squareSize,
                        width: squareSize,
                        height: squareSize
                    )
                    
                    context.fill(Path(rect), with: .color(color))
                    
                    // Check if there is a piece to be rendered on the field.
                    // If yes → Continue this iteration with the piece rendering code
                    // If no  → skip piece rendering
                    guard let piece = viewModel.pieces.first(where: {
                        $0.position.file == file && $0.position.rank == rank
                    }) else {
                        continue
                    }
                    
                    // Determine image name based on piece type and color
                    let pieceId: Int = piece.type.rawValue | piece.color.rawValue
                    var pieceString = String(pieceId, radix: 2)
                    while (pieceString.count < 4) {
                        pieceString = "0" + pieceString
                    }
                    let imageName = "2d_piece_\(pieceString)"
                    
                    // Draw piece image
                    if let uiImage = UIImage(named: imageName) {
                        let image = Image(uiImage: uiImage)
                        let imageRect = CGRect(
                            x: rect.midX - squareSize * 0.4,  // Center the image
                            y: rect.midY - squareSize * (piece.color == .white ? 0.45 : 0.33),
                            width: squareSize * 0.85,
                            height: squareSize * 0.85
                        )
                        context.draw(image, in: imageRect)
                    }
                }
            }
        }
        .cornerRadius(20)
    }
}
