import Syntax

public struct SemanticType: Hashable {
    
    public enum Kind: Hashable {
        case integerPrimitive(bitWidth: BitWidth)
        case bytePrimitive(bitWidth: BitWidth)
    }
    
    public let kind: Kind
    
    @inlinable
    internal init(_kind: Kind) {
        self.kind = _kind
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
