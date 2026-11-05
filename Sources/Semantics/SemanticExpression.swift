import Syntax
import Tokens

public struct SemanticExpression: Hashable {
    
    public enum Kind: Hashable {
        case constant(Weak<SemanticConstant>)
        case parameter(Weak<SemanticParameter>)
        case variable(Weak<SemanticVariable>)
        case `self`
        case call(toInitializer: Weak<SemanticInitializer>, passing: [SemanticExpression])
        indirect case constantMember(Weak<SemanticConstant>, of: SemanticExpression)
        indirect case variableMember(Weak<SemanticVariable>, of: SemanticExpression)
        case structurePrimitive(Weak<SemanticStructure>, constants: [SemanticExpression], variables: [SemanticExpression])
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
        SemanticExpression(_kind: .constant(Weak(constant)), at: location)
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
        SemanticExpression(_kind: .variable(Weak(variable)), at: location)
    }
    
    @inlinable
    public static func `self`(
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .self, at: location)
    }
    
    @inlinable
    public static func call(
        toInitializer initializer: SemanticInitializer,
        passing arguments: [SemanticExpression],
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(
            arguments.count == initializer.parameters.count,
            "Expected exactly \(initializer.parameters.count) arguments, but got \(arguments.count)"
        )
        return SemanticExpression(_kind: .call(toInitializer: Weak(initializer), passing: arguments), at: location)
    }
    
    @inlinable
    public static func constantMember(
        _ constant: SemanticConstant,
        of base: SemanticExpression,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .constantMember(Weak(constant), of: base), at: location)
    }
    
    @inlinable
    public static func variableMember(
        _ variable: SemanticVariable,
        of base: SemanticExpression,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(_kind: .variableMember(Weak(variable), of: base), at: location)
    }
    
    @inlinable
    public static func structurePrimitive(
        _ structure: SemanticStructure,
        constants: [SemanticExpression],
        variables: [SemanticExpression]
    ) -> SemanticExpression {
        precondition(
            constants.count == structure.constants.count,
            "Expected exactly \(structure.constants.count) constants, but got \(constants.count)"
        )
        precondition(
            variables.count == structure.variables.count,
            "Expected exactly \(structure.variables.count) variables, but got \(variables.count)"
        )
        return SemanticExpression(_kind: .structurePrimitive(Weak(structure), constants: constants, variables: variables))
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
