import Tokens

public struct ParsingError: Hashable, Error {
    
    public enum Kind: Hashable, Sendable {
        case unexpectedToken(Token)
        case unexpectedEndOfFile
    }
    
    public enum Expectation: Hashable, Sendable {
        case newlineSeparatingConsecutiveStatements
        case newlineSeparatingConsecutiveDeclarations
        case identifier
        case openingParenthesis
        case closingParenthesis
        case openingBrace
        case closingBrace
        case comma
        case colon
        case equalsSign
        case arrow
        case type
        case expression
        case argument
        case statement
        case declaration
        case externalDeclaration
        case parameter
    }
    
    public let kind: Kind
    
    public let expectation: Expectation
    
    @inlinable
    internal init(_kind: Kind, expected expectation: Expectation) {
        self.kind = _kind
        self.expectation = expectation
    }
    
    @inlinable
    public static func unexpectedToken(_ token: Token, expected expectation: Expectation) -> ParsingError {
        ParsingError(_kind: .unexpectedToken(token), expected: expectation)
    }
    
    @inlinable
    public static func unexpectedEndOfFile(expected expectation: Expectation) -> ParsingError {
        ParsingError(_kind: .unexpectedEndOfFile, expected: expectation)
    }
}

extension ParsingError: CustomStringConvertible {
    
    @inlinable
    public var description: String {
        let expectationDescription = switch expectation {
        case .newlineSeparatingConsecutiveStatements:
            "a newline that separates consecutive statements"
        case .newlineSeparatingConsecutiveDeclarations:
            "a newline that separates consecutive declarations"
        case .identifier:
            "an identifier"
        case .openingParenthesis:
            "an opening parenthesis '('"
        case .closingParenthesis:
            "a closing parenthesis ')'"
        case .openingBrace:
            "an opening brace '{'"
        case .closingBrace:
            "a closing brace '}'"
        case .comma:
            "a comma ','"
        case .colon:
            "a colon ':'"
        case .equalsSign:
            "an equals sign '='"
        case .arrow:
            "an arrow '->'"
        case .type:
            "a type"
        case .expression:
            "an expression"
        case .argument:
            "an argument"
        case .statement:
            "a statement"
        case .declaration:
            "a declaration"
        case .externalDeclaration:
            "an external declaration"
        case .parameter:
            "a parameter"
        }
        let kindDescription: String
        switch kind {
        case let .unexpectedToken(token):
            let tokenKindDescription = switch token.kind {
            case .identifier:
                "the identifier"
            case .constantKeyword,
                .externalKeyword,
                .functionKeyword,
                .initializerKeyword,
                .privateKeyword,
                .publicKeyword,
                .returnKeyword,
                .selfKeyword,
                .structureKeyword,
                .variableKeyword:
                "the keyword"
            case .integerLiteral:
                "the integer literal"
            case .openingParenthesis:
                "an opening parenthesis"
            case .closingParenthesis:
                "a closing parenthesis"
            case .openingBrace:
                "an opening brace"
            case .closingBrace:
                "a closing brace"
            case .period:
                "a period"
            case .comma:
                "a comma"
            case .colon:
                "a colon"
            case .equalsSign:
                "an equals sign"
            case .arrow:
                "an arrow"
            }
            let locationDescription = "line \(token.location.line), column \(token.location.column)"
            kindDescription = "got \(tokenKindDescription) '\(token.text)' at \(locationDescription)"
        case .unexpectedEndOfFile:
            kindDescription = "reached the end of the file"
        }
        return "Expected \(expectationDescription), but \(kindDescription)"
    }
}

extension ParsingError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        "Parsing.ParsingError(kind: \(String(reflecting: kind)), expectation: \(String(reflecting: expectation)))"
    }
}
