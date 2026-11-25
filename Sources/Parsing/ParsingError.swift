import SystemPackage

import Tokens

public struct ParsingError: Hashable, Error {
    
    public enum Kind: Sendable {
        case unexpectedToken(Token)
        case unexpectedEndOfFile(at: SourceLocation)
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
        case statement
        case declaration
        case externalDeclaration
        case accessLevel
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
    public static func unexpectedToken(
        _ token: Token,
        expected expectation: Expectation
    ) -> ParsingError { ParsingError(_kind: .unexpectedToken(token), expected: expectation) }
    
    @inlinable
    public static func unexpectedEndOfFile(
        at location: SourceLocation,
        expected expectation: Expectation
    ) -> ParsingError { ParsingError(_kind: .unexpectedEndOfFile(at: location), expected: expectation) }
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
        case .statement:
            "a statement"
        case .declaration:
            "a declaration"
        case .externalDeclaration:
            "an external declaration"
        case .accessLevel:
            "an access level"
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
                .protocolKeyword,
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
            kindDescription = "got \(tokenKindDescription) '\(token.text)'"
        case .unexpectedEndOfFile:
            kindDescription = "reached the end of the file"
        }
        let location = switch kind {
        case let .unexpectedToken(token):
            token.location
        case let .unexpectedEndOfFile(at: location):
            location
        }
        let locationDescription = "line \(location.line), column \(location.column) in \(location.path)"
        return "Expected \(expectationDescription), but \(kindDescription) at \(locationDescription)"
    }
}

extension ParsingError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        "Parsing.ParsingError(kind: \(String(reflecting: kind)), expectation: \(String(reflecting: expectation)))"
    }
}

extension ParsingError.Kind: Equatable {
    
    @inlinable
    public static func == (lhs: ParsingError.Kind, rhs: ParsingError.Kind) -> Bool {
        switch (lhs, rhs) {
        case let (.unexpectedToken(lhToken), .unexpectedToken(rhToken)):
            lhToken == rhToken && lhToken.location == rhToken.location
        case let (.unexpectedEndOfFile(at: lhLocation), .unexpectedEndOfFile(at: rhLocation)):
            lhLocation == rhLocation
        default:
            false
        }
    }
}

extension ParsingError.Kind: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .unexpectedToken(token):
            hasher.combine(token)
            hasher.combine(token.location)
        case let .unexpectedEndOfFile(at: location):
            hasher.combine(location)
        }
    }
}
