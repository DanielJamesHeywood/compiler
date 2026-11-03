import Syntax
import Tokens

public struct SemanticType: Hashable {
    
    public enum Kind: Hashable {
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
    public static func integerPrimitive(bitWidth: BitWidth) -> SemanticType {
        SemanticType(_kind: .integerPrimitive(bitWidth: bitWidth))
    }
    
    @inlinable
    public static func bytePrimitive(bitWidth: BitWidth) -> SemanticType {
        SemanticType(_kind: .bytePrimitive(bitWidth: bitWidth))
    }
}
