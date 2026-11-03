import Syntax
import Tokens

public struct SemanticExpression: Hashable {
    
    public enum Kind: Hashable {
        case primitiveInteger(words: [UInt64], bitWidth: BitWidth)
        case primitiveByte(words: [UInt64], bitWidth: BitWidth)
        indirect case primitiveBitCast(of: SemanticExpression, to: SemanticType)
        indirect case primitiveTruncation(of: SemanticExpression, to: SemanticType)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation? = nil) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func primitiveInteger(words: [UInt64], bitWidth: BitWidth) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveInteger(words: words, bitWidth: bitWidth))
    }
    
    @inlinable
    public static func primitiveByte(words: [UInt64], bitWidth: BitWidth) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveByte(words: words, bitWidth: bitWidth))
    }
    
    @inlinable
    public static func primitiveBitCast(of value: SemanticExpression, to type: SemanticType) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveBitCast(of: value, to: type))
    }
    
    @inlinable
    public static func primitiveTruncation(of value: SemanticExpression, to type: SemanticType) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveTruncation(of: value, to: type))
    }
}
