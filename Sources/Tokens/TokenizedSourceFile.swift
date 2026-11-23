public struct TokenizedSourceFile: Sendable {
    
    public let tokens: [Token]
    
    public let endLocation: SourceLocation
    
    @inlinable
    public init(tokens: [Token], endingAt location: SourceLocation) {
        self.tokens = tokens
        self.endLocation = location
    }
}

extension TokenizedSourceFile: Equatable {
    
    @inlinable
    public static func == (lhs: TokenizedSourceFile, rhs: TokenizedSourceFile) -> Bool { lhs.tokens == rhs.tokens }
}

extension TokenizedSourceFile: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(tokens)
    }
}
