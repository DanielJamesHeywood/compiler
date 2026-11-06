import Syntax
import Tokens

public struct SemanticType: Hashable {
    
    public enum Kind: Hashable {
        case structure(Weak<SemanticStructure>)
        case integerPrimitive(bitWidth: BitWidth)
        case bytePrimitive(bitWidth: BitWidth)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation?) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func structure(_ structure: SemanticStructure, at location: SourceLocation?) -> SemanticType {
        SemanticType(_kind: .structure(Weak(structure)), at: location)
    }
    
    @inlinable
    public static func integerPrimitive(bitWidth: BitWidth, at location: SourceLocation?) -> SemanticType {
        SemanticType(_kind: .integerPrimitive(bitWidth: bitWidth), at: location)
    }
    
    @inlinable
    public static func bytePrimitive(bitWidth: BitWidth, at location: SourceLocation?) -> SemanticType {
        SemanticType(_kind: .bytePrimitive(bitWidth: bitWidth), at: location)
    }
}
