public struct Token: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case identifier(Identifier)
        case constantKeyword
        case externalKeyword
        case functionKeyword
        case initializerKeyword
        case privateKeyword
        case publicKeyword
        case returnKeyword
        case selfKeyword
        case structureKeyword
        case variableKeyword
        case integerLiteral(IntegerLiteral)
        case openingParenthesis
        case closingParenthesis
        case openingBrace
        case closingBrace
        case period
        case comma
        case colon
        case equalsSign
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
    public static func constantKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .constantKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
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
    public static func initializerKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .initializerKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func privateKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .privateKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
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
    public static func selfKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .selfKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func structureKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .structureKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func variableKeyword(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .variableKeyword, isAtStartOfLine: isAtStartOfLine, at: location)
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
    public static func period(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .period, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func comma(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .comma, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func colon(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .colon, isAtStartOfLine: isAtStartOfLine, at: location)
    }
    
    @inlinable
    public static func equalsSign(isAtStartOfLine: Bool, at location: SourceLocation) -> Token {
        Token(_kind: .equalsSign, isAtStartOfLine: isAtStartOfLine, at: location)
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
        case .constantKeyword:
            "constant"
        case .externalKeyword:
            "external"
        case .functionKeyword:
            "function"
        case .initializerKeyword:
            "initializer"
        case .privateKeyword:
            "private"
        case .publicKeyword:
            "public"
        case .returnKeyword:
            "return"
        case .selfKeyword:
            "self"
        case .structureKeyword:
            "structure"
        case .variableKeyword:
            "variable"
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
        case .period:
            "."
        case .comma:
            ","
        case .colon:
            ":"
        case .equalsSign:
            "="
        case .arrow:
            "->"
        }
    }
}
