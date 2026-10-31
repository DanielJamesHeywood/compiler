import Tokens

public struct SyntacticType: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case identifier(Identifier)
        case integerPrimitive(bitWidth: BitWidth)
        case bytePrimitive(bitWidth: BitWidth)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation? = nil) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func identifier(_ identifier: Identifier, at location: SourceLocation? = nil) -> SyntacticType {
        SyntacticType(_kind: .identifier(identifier), at: location)
    }

    @inlinable
    public static func integerPrimitive(bitWidth: BitWidth) -> SyntacticType {
        SyntacticType(_kind: .integerPrimitive(bitWidth: bitWidth))
    }

    @inlinable
    public static func bytePrimitive(bitWidth: BitWidth) -> SyntacticType {
        SyntacticType(_kind: .bytePrimitive(bitWidth: bitWidth))
    }
}
