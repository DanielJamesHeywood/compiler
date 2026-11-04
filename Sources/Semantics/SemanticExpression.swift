import Syntax
import Tokens

public struct SemanticExpression {
    
    public enum Kind: Hashable {
        case constant(Weak<SemanticConstant>)
        case parameter(Weak<SemanticParameter>)
        case variable(Weak<SemanticVariable>)
        case call(toInitializer: Weak<SemanticInitializer>, passing: [SemanticExpression])
        indirect case constantMember(Weak<SemanticConstant>, of: SemanticExpression)
        indirect case variableMember(Weak<SemanticVariable>, of: SemanticExpression)
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
    public static func constant(
        _ constant: SemanticConstant,
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(constant.container == nil, "The constant is a member of a structure")
        return SemanticExpression(_kind: .constant(Weak(constant)), at: location)
    }
    
    @inlinable
    public static func parameter(
        _ parameter: SemanticParameter,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .parameter(Weak(parameter)), at: location)
    }
    
    @inlinable
    public static func variable(
        _ variable: SemanticVariable,
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(variable.container == nil, "The variable is a member of a structure")
        return SemanticExpression(_kind: .variable(Weak(variable)), at: location)
    }
    
    @inlinable
    public static func call(
        toInitializer initializer: SemanticInitializer,
        passing arguments: [SemanticExpression],
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .call(toInitializer: Weak(initializer), passing: arguments), at: location)
    }
    
    @inlinable
    public static func constantMember(
        _ constant: SemanticConstant,
        of base: SemanticExpression,
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(constant.container != nil, "The constant is not a member of a structure")
        return SemanticExpression(_kind: .constantMember(Weak(constant), of: base), at: location)
    }
    
    @inlinable
    public static func variableMember(
        _ variable: SemanticVariable,
        of base: SemanticExpression,
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(variable.container != nil, "The variable is not a member of a structure")
        return SemanticExpression(_kind: .variableMember(Weak(variable), of: base), at: location)
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
    
    @inlinable
    public var type: SemanticType {
        switch kind {
        case let .constant(weakConstant), let .constantMember(weakConstant, of: _):
            weakConstant.object.type
        case let .parameter(weakParameter):
            weakParameter.object.type
        case let .variable(weakVariable), let .variableMember(weakVariable, of: _):
            weakVariable.object.type
        case let .call(toInitializer: weakInitializer, passing: _):
            switch weakInitializer.object.container {
            case let .structure(weakStructure):
                .structure(weakStructure.object, at: nil)
            }
        case let .integerPrimitive(words: _, bitWidth: bitWidth):
            .bytePrimitive(bitWidth: bitWidth)
        case let .bytePrimitive(words: _, bitWidth: bitWidth):
            .integerPrimitive(bitWidth: bitWidth)
        case let .primitiveTruncation(of: _, to: type), let .primitiveBitCast(of: _, to: type):
            type
        }
    }
}

extension SemanticExpression: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticExpression, rhs: SemanticExpression) -> Bool { lhs.kind == rhs.kind }
}

extension SemanticExpression: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
    }
}
