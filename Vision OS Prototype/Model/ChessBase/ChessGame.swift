import Foundation

class ChessGame {
    /// The chessboard representing the current state of the game.
    public private(set) var board: ChessBoard
    
    /// The color of the player whose turn it is.
    public private(set) var colorOnTurn: PieceColor = .white
    /// Indicates whether the game has ended.
    public private(set) var isGameOver: Bool = false
    /// The result of the game if it has ended.
    public private(set) var result: ChessGameResult?
    /// The history of all moves played in the game.
    public private(set) var moveHistory: [ChessMove] = []
    
    init() {
        self.board = ChessBoard()
    }
    
    /// Reverts the last move played in the game, restoring the previous game state.
    public func revertLastMove() {
        guard let lastMove = self.moveHistory.last else { return }
        
        if lastMove.isCaptureMove {
            self.board.setPiece(on: lastMove.target, type: lastMove.capturedPiece!, color: lastMove.movedPiece.color == .white ? .black : .white)
        }
        
        if lastMove.isCastlingMove {
            let possibleRookOrigins: [ChessBoardField] = lastMove.movedPiece.color == .white ? [.A1, .H1] : [.A8, .H8]
            let possibleRookDestinations: [ChessBoardField] = lastMove.movedPiece.color == .white ? [.C1, .F1] : [.C8, .F8]
            let correspondingRookOrigin = lastMove.target.file > 4 ? possibleRookOrigins[1] : possibleRookOrigins[0]
            let correspondingRookTarget = lastMove.target.file > 4 ? possibleRookDestinations[1] : possibleRookDestinations[0]
            
            self.board.movePiece(from: correspondingRookTarget, to: correspondingRookOrigin)
        }
        
        if lastMove.isEnPassantMove {
            let targetIndex = lastMove.movedPiece.color == .white ? lastMove.target.index - 8 : lastMove.target.index + 8
            let targetField = ChessBoardField(index: targetIndex)!
            
            self.board.setPiece(on: targetField, type: .pawn, color: lastMove.movedPiece.color == .white ? .white : .black)
        }
        
        if lastMove.isPromotionMove {
            self.board.setPiece(on: lastMove.target, type: .pawn, color: lastMove.movedPiece.color)
        }
        
        self.moveHistory.removeLast()
        self.board.movePiece(from: lastMove.target, to: lastMove.origin)
        
        toggleColorOnTurn()
    }
    
    /// Adds a move to the game history and updates the board accordingly.
    /// - Parameters:
    ///   - origin: The starting position of the piece being moved.
    ///   - target: The destination position of the piece being moved.
    public func addMove(from origin: ChessBoardField, to target: ChessBoardField) {
        guard let piece = self.board.getPiece(at: origin) else {
            print("Move could not be added, because no piece is on \(origin)")
            return
        }
        
        let move = ChessMove(from: origin, to: target, which: piece, isCapture: board.getPiece(at: target) != nil, capturedPiece: self.board.getPiece(at: target)?.type)
        self.moveHistory.append(move)
        self.board.movePiece(from: origin, to: target)
        
        if move.isCastlingMove {
            let possibleRookOrigins: [ChessBoardField] = move.movedPiece.color == .white ? [.A1, .H1] : [.A8, .H8]
            let possibleRookDestinations: [ChessBoardField] = move.movedPiece.color == .white ? [.C1, .F1] : [.C8, .F8]
            let correspondingRookOrigin = move.target.file > 4 ? possibleRookOrigins[1] : possibleRookOrigins[0]
            let correspondingRookTarget = move.target.file > 4 ? possibleRookDestinations[1] : possibleRookDestinations[0]
            
            self.board.movePiece(from: correspondingRookOrigin, to: correspondingRookTarget)
        }
        
        if move.isEnPassantMove {
            move.isCaptureMove = true
            move.capturedPiece = .pawn
            
            let targetIndex = move.movedPiece.color == .white ? move.target.index - 8 : move.target.index + 8
            let targetField = ChessBoardField(index: targetIndex)!
            
            self.board.removePiece(from: targetField)
        }
        
        if move.isPromotionMove {
            self.board.setPiece(on: move.target, type: .queen, color: move.movedPiece.color) // Always promote to queen for simplicity
        }
        
        toggleColorOnTurn()
    }
    
    /// Declares a winner and ends the game.
    /// - Parameter color: The color of the winning player.
    public func declareWinner(color: PieceColor) {
        self.isGameOver = true
        self.result = .checkmate(for: color)
    }
    
    /// Declares the game as a draw and ends it.
    public func declareDraw() {
        self.isGameOver = true
        self.result = .draw
    }
    
    /// Sets the player whose turn it is.
    /// - Parameter color: The color of the player to set as the current turn.
    public func setColorOnTurn(color: PieceColor) { self.colorOnTurn = color }
    
    /// Switches the turn to the other player.
    public func toggleColorOnTurn() { self.colorOnTurn = self.colorOnTurn == .white ? .black : .white }
}
