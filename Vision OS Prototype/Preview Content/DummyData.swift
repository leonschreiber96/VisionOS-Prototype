//
//  DummyData.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 23.01.25.
//

class DummyData {
    let players: [Player] = [
        .init(name: "Max", gender: "male", nationality: "Germany", age: 33, aktuelleELOZahl: 2985, besteELOZahl: 3150, titel: "IM", beschreibung: "An experienced competitor."),
        .init(name: "Hannah", gender: "female", nationality: "Germany", age: 30, aktuelleELOZahl: 2840, besteELOZahl: 2960, titel: "WIM", beschreibung: "Talented strategist, with a strong defense."),
        .init(name: "Luca", gender: "male", nationality: "Italy", age: 22, aktuelleELOZahl: 2400, besteELOZahl: 2575, titel: "FM", beschreibung: "A rising star with a sharp tactical mind."),
        .init(name: "Giulia", gender: "female", nationality: "Italy", age: 28, aktuelleELOZahl: 2650, besteELOZahl: 2705, titel: "IM", beschreibung: "Tactical genius, focused on fast attacks."),
        .init(name: "Erik", gender: "male", nationality: "Sweden", age: 29, aktuelleELOZahl: 2600, besteELOZahl: 2750, titel: "GM", beschreibung: "Strong in the endgame, analytical."),
        .init(name: "Sofie", gender: "female", nationality: "Sweden", age: 34, aktuelleELOZahl: 2460, besteELOZahl: 2600, titel: "WIM", beschreibung: "An excellent player with a good understanding of positions."),
        .init(name: "Andreas", gender: "male", nationality: "Germany", age: 37, aktuelleELOZahl: 3100, besteELOZahl: 3250, titel: "GM", beschreibung: "A world-class player known for his opening theory."),
        .init(name: "Eva", gender: "female", nationality: "Germany", age: 24, aktuelleELOZahl: 2200, besteELOZahl: 2300, titel: "WIM", beschreibung: "Rising star with strong tactical skills."),
        .init(name: "Francesco", gender: "male", nationality: "Italy", age: 31, aktuelleELOZahl: 2790, besteELOZahl: 2900, titel: "GM", beschreibung: "A strategic powerhouse, focused on deep analysis."),
        .init(name: "Lorenzo", gender: "male", nationality: "Italy", age: 25, aktuelleELOZahl: 2550, besteELOZahl: 2650, titel: "FM", beschreibung: "Passionate about classic positions and maneuvering."),
        .init(name: "Linnea", gender: "female", nationality: "Sweden", age: 32, aktuelleELOZahl: 2670, besteELOZahl: 2755, titel: "WGM", beschreibung: "Creative and aggressive style of play."),
        .init(name: "Oskar", gender: "male", nationality: "Sweden", age: 27, aktuelleELOZahl: 2505, besteELOZahl: 2650, titel: "FM", beschreibung: "Enjoys tactical positions and dynamic sacrifices."),
        .init(name: "Nina", gender: "female", nationality: "Germany", age: 29, aktuelleELOZahl: 2680, besteELOZahl: 2735, titel: "WIM", beschreibung: "Focused and sharp, with a love for positional play."),
        .init(name: "Felix", gender: "male", nationality: "Germany", age: 23, aktuelleELOZahl: 2400, besteELOZahl: 2550, titel: "FM", beschreibung: "Aggressive and fast, great at blitz games."),
        .init(name: "Samantha", gender: "female", nationality: "Italy", age: 35, aktuelleELOZahl: 2730, besteELOZahl: 2800, titel: "WGM", beschreibung: "Quiet and solid player, with great experience."),
        .init(name: "Matteo", gender: "male", nationality: "Italy", age: 29, aktuelleELOZahl: 2625, besteELOZahl: 2700, titel: "IM", beschreibung: "Enjoys deep opening preparation and surprises."),
    ]
    
    let moves: [ChessMove] = [
        .init(from: .G1, to: .F3, which: (type: .knight, color: .white)),
        .init(from: .D7, to: .D5, which: (type: .pawn, color: .black)),
        .init(from: .G2, to: .G3, which: (type: .pawn, color: .white)),
        .init(from: .B8, to: .C6, which: (type: .knight, color: .black)),
        .init(from: .F1, to: .G2, which: (type: .bishop, color: .white)),
        .init(from: .G8, to: .F6, which: (type: .knight, color: .black)),
        .init(from: .E1, to: .G1, which: (type: .king, color: .white)),
        .init(from: .E7, to: .E5, which: (type: .pawn, color: .black)),
        .init(from: .D2, to: .D3, which: (type: .pawn, color: .white)),
        .init(from: .E5, to: .E4, which: (type: .pawn, color: .black)),
        .init(from: .C1, to: .G5, which: (type: .bishop, color: .white)),
        .init(from: .E4, to: .F3, which: (type: .pawn, color: .black)),
        .init(from: .G2, to: .F3, which: (type: .bishop, color: .white)),
        .init(from: .H7, to: .H6, which: (type: .pawn, color: .black)),
        .init(from: .G5, to: .F6, which: (type: .bishop, color: .white)),
        .init(from: .D8, to: .F6, which: (type: .queen, color: .black)),
        .init(from: .B1, to: .D2, which: (type: .knight, color: .white)),
        .init(from: .D5, to: .D4, which: (type: .pawn, color: .black)),
        .init(from: .F1, to: .E1, which: (type: .rook, color: .white)),
        .init(from: .F8, to: .D6, which: (type: .bishop, color: .black)),
        .init(from: .E2, to: .E4, which: (type: .pawn, color: .white)),
        .init(from: .E8, to: .G8, which: (type: .king, color: .black)),
        .init(from: .E4, to: .E5, which: (type: .pawn, color: .white)),
        .init(from: .D6, to: .E5, which: (type: .bishop, color: .black)),
        .init(from: .F3, to: .C6, which: (type: .bishop, color: .white)),
        .init(from: .B7, to: .C6, which: (type: .pawn, color: .black)),
        .init(from: .D2, to: .E4, which: (type: .knight, color: .white)),
        .init(from: .F6, to: .E6, which: (type: .queen, color: .black)),
        .init(from: .E4, to: .C5, which: (type: .knight, color: .white)),
        .init(from: .E6, to: .H3, which: (type: .queen, color: .black)),
        .init(from: .D1, to: .F3, which: (type: .queen, color: .white)),
        .init(from: .A8, to: .B8, which: (type: .rook, color: .black)),
        .init(from: .C5, to: .A6, which: (type: .knight, color: .white)),
        .init(from: .B8, to: .B2, which: (type: .rook, color: .black)),
        .init(from: .A2, to: .A4, which: (type: .pawn, color: .white)),
        .init(from: .B2, to: .C2, which: (type: .rook, color: .black)),
        .init(from: .F3, to: .C6, which: (type: .queen, color: .white)),
        .init(from: .E5, to: .G3, which: (type: .bishop, color: .black)),
        .init(from: .F2, to: .G3, which: (type: .pawn, color: .white)),
        .init(from: .H3, to: .G2, which: (type: .queen, color: .black)),
        .init(from: .C6, to: .G2, which: (type: .queen, color: .white)),
        .init(from: .C2, to: .G2, which: (type: .rook, color: .black)),
        .init(from: .G1, to: .G2, which: (type: .king, color: .white))
    ]

    
    func generateRandomGame() -> ChessGame {
        let game = ChessGame()
        
        for i in 0..<Int.random(in: 10...moves.count) {
            let move = moves[i]
            game.addMove(from: move.origin, to: move.target)
        }
        
        if (Bool.random()) {
            game.declareWinner(color: .white)
        } else if (Bool.random()) {
            game.declareWinner(color: .black)
        } else if (Bool.random()) {
            game.declareDraw()
        }
        
        return game
    }
    
    func generateRandomEvent() -> ChessEvent {
        let game = generateRandomGame()
        let whitePlayer = players[Int.random(in: 0..<players.count)]
        let blackPlayer = players[Int.random(in: 0..<players.count)]
        let event = ChessEvent(game: game, players: (white: whitePlayer, black: blackPlayer), gameTime: 300)
        return event
    }
}
