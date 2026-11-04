import Tokens

public struct SyntacticType: Sendable {
    
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

extension SyntacticType: Equatable {
    
    @inlinable
    public static func == (lhs: SyntacticType, rhs: SyntacticType) -> Bool { lhs.kind == rhs.kind }
}

extension SyntacticType: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
    }
}
