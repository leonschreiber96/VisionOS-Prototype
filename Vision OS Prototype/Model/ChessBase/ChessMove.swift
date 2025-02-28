import Foundation

/**
 Represents a single move in a chess game, with an origin and a destination.
 
 - Holds information about the piece being moved and metadata such as if it is a special type of move (castling, en passant, promotion, capture)
 - Contains utility functions to convert to printable representations.
 */
class ChessMove: Identifiable {
    /// Unique identifier for the move.
    let guid = UUID()
    
    /// The starting position of the moved piece.
    var origin: ChessBoardField
    /// The destination position of the moved piece.
    var target: ChessBoardField
    /// The piece being moved, including its type and color.
    var movedPiece: (type: PieceType, color: PieceColor)
    
    /// Indicates if the move is a castling move.
    var isCastlingMove: Bool = false
    /// Indicates if the move is a pawn promotion.
    var isPromotionMove: Bool = false
    /// Indicates if the move is an en passant capture.
    var isEnPassantMove: Bool = false
    /// Indicates if the move captures an opponent's piece.
    var isCaptureMove: Bool = false
    /// The type of the captured piece, if any.
    var capturedPiece: PieceType?
    
    init(from origin: ChessBoardField, to target: ChessBoardField, which piece: (type: PieceType, color: PieceColor), isCapture: Bool = false, capturedPiece: PieceType? = nil) {
        self.origin = origin
        self.target = target
        self.movedPiece = piece
        
        self.isCastlingMove = self.determineIfCastlingMove()
        self.isPromotionMove = self.determineIfPromotionMove()
        self.isEnPassantMove = self.determineIfEnPassantMove()
        self.isCaptureMove = isCapture
        self.capturedPiece = capturedPiece
    }
    
    /// Returns the algebraic notation representation of the move (see [Wikipedia](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)))
    public func getAlgebraicNotation() -> String {
        if self.isCastlingMove && self.target.file == 2 { return "O-O-O" }
        if self.isCastlingMove && self.target.file == 6 { return "O-O" }
        
        var notation: String = ""
        
        switch self.movedPiece.type {
        case .knight: notation += "♞"
        case .bishop: notation += "♝"
        case .rook: notation += "♜"
        case .queen: notation += "♛"
        case .king: notation += "♚"
        default: break
        }
        
        if self.isCaptureMove {
            if self.movedPiece.type == .pawn {
                notation += String("abcdefgh"["abcdefgh".index("abcdefgh".startIndex, offsetBy: self.origin.file)])
            }
            notation += "x"
        }
        
        notation += self.target.rawValue.lowercased()
        
        if self.isEnPassantMove { notation += "e.p." }
        
        return notation
    }
    
    /// Determines if the move is a castling move.
    private func determineIfCastlingMove() -> Bool {
        return self.movedPiece.type == .king && abs(self.origin.index - self.target.index) == 2
    }
    
    /// Determines if the move is a promotion move.
    private func determineIfPromotionMove() -> Bool {
        return self.movedPiece.type == .pawn && self.target.rank == (self.movedPiece.color == .white ? 7 : 0)
    }
    
    /// Determines if the move is an en passant move.
    private func determineIfEnPassantMove() -> Bool {
        return self.movedPiece.type == .pawn && abs(self.target.file - self.origin.file) == 2
    }
}
