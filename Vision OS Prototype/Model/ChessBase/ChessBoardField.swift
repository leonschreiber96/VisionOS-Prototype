//
//  ChessBoardField.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import Foundation

/**
 Represents a field on a chess board.
 
 # Initialization
 ```swift
 // Directly select the field from the available enum values
 let field = ChessBoardField.A1
 
 // Initialize from an index in the range 0...63 (A1 → `0`, A2 → `1`, ... H8 → `63`)
 let field = ChessBoardField(index: 0)
 ```
 */
enum ChessBoardField: String, CaseIterable {
    case A1, A2, A3, A4, A5, A6, A7, A8
    case B1, B2, B3, B4, B5, B6, B7, B8
    case C1, C2, C3, C4, C5, C6, C7, C8
    case D1, D2, D3, D4, D5, D6, D7, D8
    case E1, E2, E3, E4, E5, E6, E7, E8
    case F1, F2, F3, F4, F5, F6, F7, F8
    case G1, G2, G3, G4, G5, G6, G7, G8
    case H1, H2, H3, H4, H5, H6, H7, H8
    
    /// Get the index of the field in an array of all 64 possible fields (A1 → `0`, A2 → `1`, ... H8 → `63`).
    var index: Int {
        // Use '!' operator because all possible raw values have the same structure and won't return nil for `first` and `last`.
        let letter = self.rawValue.first!
        let number = String(self.rawValue.last!)
        
        let column = Int(letter.asciiValue! - 65) // 65 → ASCII value of 'A'
        let row = Int(number)! - 1
        
        return row * 8 + column
    }
    
    /// "Rank" corresponds to "Row" → Increases in direction facing away from the **white** player.
    var rank: Int { self.index / 8 }
    /// "File" corresponds to "Column" → Increases from the **white** player's left to his right.
    var file: Int { self.index % 8 }
    
    /// Initialize from an index in the range 0...63 (A1 → `0`, A2 → `1`, ... H8 → `63`). **Can return `nil` if index is out of range!**
    init?(index: Int) {
       guard index >= 0 && index < 64 else {
           return nil
       }
       
       let row = index / 8
       let column = index % 8
       
       let letter = Character(UnicodeScalar(Int("A".unicodeScalars.first!.value) + column)!)
       let number = String(row + 1)
       let fieldString = "\(letter)\(number)"
        
       self.init(rawValue: fieldString)
   }
}
