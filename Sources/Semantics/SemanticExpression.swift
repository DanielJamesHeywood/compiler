import Syntax

public struct SemanticExpression: Hashable {
    
    public enum Kind: Hashable {
        case primitiveInteger(words: [UInt64], bitWidth: BitWidth)
        case primitiveByte(words: [UInt64], bitWidth: BitWidth)
    }
    
    public let kind: Kind
    
    @inlinable
    internal init(_kind: Kind) {
        self.kind = _kind
    }
    
    @inlinable
    public static func primitiveInteger(words: [UInt64], bitWidth: BitWidth) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveInteger(words: words, bitWidth: bitWidth))
    }
    
    @inlinable
    public static func primitiveByte(words: [UInt64], bitWidth: BitWidth) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveByte(words: words, bitWidth: bitWidth))
    }
}
