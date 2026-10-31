import Tokens

public struct LexingError: Hashable, Error {
    
    public enum Kind: Hashable, Sendable {
        case unexpectedCharacter(Character)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func unexpectedCharacter(_ character: Character, at location: SourceLocation) -> LexingError {
        LexingError(_kind: .unexpectedCharacter(character), at: location)
    }
}

extension LexingError: CustomStringConvertible {
    
    @inlinable
    public var description: String {
        let message = switch kind {
        case let .unexpectedCharacter(character):
            "Unexpected character '\(character.debugDescription.dropFirst().dropLast())'"
        }
        return "\(message) at line \(location.line), column \(location.column)"
    }
}

extension LexingError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        "Lexing.LexingError(kind: \(String(reflecting: kind)), location: \(String(reflecting: location)))"
    }
}
