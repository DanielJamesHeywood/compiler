import Syntax
import Tokens

public struct SemanticType {
    
    public enum Kind: Hashable {
        case structure(Weak<SemanticStructure>)
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
    public static func structure(_ structure: SemanticStructure, at location: SourceLocation?) -> SemanticType {
        SemanticType(_kind: .structure(Weak(structure)), at: location)
    }
    
    @inlinable
    public static func integerPrimitive(bitWidth: BitWidth) -> SemanticType {
        SemanticType(_kind: .integerPrimitive(bitWidth: bitWidth))
    }
    
    @inlinable
    public static func bytePrimitive(bitWidth: BitWidth) -> SemanticType {
        SemanticType(_kind: .bytePrimitive(bitWidth: bitWidth))
    }
}

extension SemanticType: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticType, rhs: SemanticType) -> Bool { lhs.kind == rhs.kind }
}

extension SemanticType: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
    }
}
