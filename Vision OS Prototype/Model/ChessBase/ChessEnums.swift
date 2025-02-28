//
//  ChessGameResult.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//


import Foundation

/**
 Types of chess pieces. Can be combined with ``PieceColor`` enum by using a logical **OR**, thus creating a unique integer representation for each possible piece type/color combination.
 
 # Usage
 ```swift
 let pawn = PieceType.pawn
 let whitePawn = PieceType.pawn | PieceColor.white
 ```
*/
enum PieceType: Int {
    case pawn = 0b001
    case rook = 0b010
    case knight = 0b011
    case bishop = 0b100
    case king = 0b101
    case queen = 0b110
}

/**
 Colors of chess pieces. Can be combined with ``PieceType`` enum by using a logical **OR**, thus creating a unique integer representation for each possible piece type/color combination.
 
 # Usage
 ```swift
 let pawn = PieceType.pawn
 let whitePawn = PieceType.pawn | PieceColor.white
 ```
*/
enum PieceColor: Int {
    case white = 0b1000
    case black = 0b0000
}

/// Possible results of a chess game.
enum ChessGameResult: Equatable {
    case draw
    case checkmate(for: PieceColor)
}
