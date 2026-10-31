public struct Token: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case identifier(Identifier)
        case externalKeyword
        case functionKeyword
        case publicKeyword
        case returnKeyword
        case integerLiteral(IntegerLiteral)
        case openingParenthesis
        case closingParenthesis
        case openingBrace
        case closingBrace
        case arrow
    }
    
    public let kind: Kind
    
    public let isAtStartOfLine: Bool
    
    public let location: SourceLocation
    
    @inlinable
    internal init(_kind: Kind, isAtStartOfLine: Bool, at location: SourceLocation) {
        self.kind = _kind
        self.isAtStartOfLine = isAtStartOfLine
        self.location = location
    }
    
    @inlinable
    public static func identifier(_ text: Substring, isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .identifier(Identifier(text)), isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func externalKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .externalKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func functionKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .functionKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func publicKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .publicKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func returnKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .returnKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func integerLiteral(_ text: Substring, isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .integerLiteral(IntegerLiteral(text)), isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func openingParenthesis(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .openingParenthesis, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func closingParenthesis(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .closingParenthesis, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func openingBrace(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .openingBrace, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func closingBrace(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .closingBrace, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func arrow(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .arrow, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public var text: String {
        switch kind {
        case let .identifier(identifier):
            identifier.text
        case .externalKeyword:
            "external"
        case .functionKeyword:
            "function"
        case .publicKeyword:
            "public"
        case .returnKeyword:
            "return"
        case let .integerLiteral(literal):
            literal.text
        case .openingParenthesis:
            "("
        case .closingParenthesis:
            ")"
        case .openingBrace:
            "{"
        case .closingBrace:
            "}"
        case .arrow:
            "->"
        }
    }
}
