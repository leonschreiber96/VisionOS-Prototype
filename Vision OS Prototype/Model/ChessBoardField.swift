//
//  ChessBoardField.swift
//  Vision OS Prototype
//
//  Created by Leon Schreiber on 21.01.25.
//

import Foundation

enum ChessBoardField: String, CaseIterable {
    case A1, A2, A3, A4, A5, A6, A7, A8
    case B1, B2, B3, B4, B5, B6, B7, B8
    case C1, C2, C3, C4, C5, C6, C7, C8
    case D1, D2, D3, D4, D5, D6, D7, D8
    case E1, E2, E3, E4, E5, E6, E7, E8
    case F1, F2, F3, F4, F5, F6, F7, F8
    case G1, G2, G3, G4, G5, G6, G7, G8
    case H1, H2, H3, H4, H5, H6, H7, H8
    
    var index: Int {
        let letter = self.rawValue.first!
        let number = String(self.rawValue.last!)
        
        let column = Int(letter.asciiValue! - 65)
        let row = Int(number)! - 1
        
        return row * 8 + column
    }
    
    var rank: Int { self.index / 8 }
    var file: Int { self.index % 8 }
    
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
