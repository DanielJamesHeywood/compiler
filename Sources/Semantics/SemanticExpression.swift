import Syntax
import Tokens

public struct SemanticExpression: Hashable {
    
    public enum Kind: Hashable {
        case parameter(Weak<SemanticParameter>)
        case call(toInitializer: Weak<SemanticInitializer>, passing: [SemanticExpression])
        case integerPrimitive(words: [UInt64], bitWidth: BitWidth)
        case bytePrimitive(words: [UInt64], bitWidth: BitWidth)
        indirect case primitiveTruncation(of: SemanticExpression, to: SemanticType)
        indirect case primitiveBitCast(of: SemanticExpression, to: SemanticType)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation? = nil) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func parameter(
        _ parameter: SemanticParameter,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .parameter(Weak(parameter)), at: location)
    }
    
    @inlinable
    public static func call(
        toInitializer initializer: Weak<SemanticInitializer>,
        passing arguments: [SemanticExpression],
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .call(toInitializer: initializer, passing: arguments), at: location)
    }
    
    @inlinable
    public static func integerPrimitive(
        words: [UInt64],
        bitWidth: BitWidth
    ) -> SemanticExpression {
        SemanticExpression(_kind: .integerPrimitive(words: words, bitWidth: bitWidth))
    }
    
    @inlinable
    public static func bytePrimitive(
        words: [UInt64],
        bitWidth: BitWidth
    ) -> SemanticExpression {
        SemanticExpression(_kind: .bytePrimitive(words: words, bitWidth: bitWidth))
    }
    
    @inlinable
    public static func primitiveTruncation(
        of value: SemanticExpression,
        to type: SemanticType
    ) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveTruncation(of: value, to: type))
    }
    
    @inlinable
    public static func primitiveBitCast(
        of value: SemanticExpression,
        to type: SemanticType
    ) -> SemanticExpression {
        SemanticExpression(_kind: .primitiveBitCast(of: value, to: type))
    }
}
