import Tokens
import Syntax

public struct SemanticExpression {
    
    public enum Kind: Hashable {
        case constant(SemanticConstant)
        case variable(SemanticVariable)
        case parameter(SemanticParameter)
        case `self`
        case call(toInitializers: [Weak<SemanticInitializer>], passing: [SemanticExpression])
        indirect case property(SemanticProperty, of: SemanticExpression)
        case structurePrimitive(Weak<SemanticStructure>, propertyValues: [SemanticExpression])
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
        SemanticExpression(
            _kind: .constant(constant),
            at: location
        )
    }
    
    @inlinable
    public static func variable(
        _ variable: SemanticVariable,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .variable(variable),
            at: location
        )
    }
    
    @inlinable
    public static func parameter(
        _ parameter: SemanticParameter,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .parameter(parameter),
            at: location
        )
    }
    
    @inlinable
    public static func `self`(
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .self,
            at: location
        )
    }
    
    @inlinable
    public static func call(
        toInitializers initializers: [SemanticInitializer],
        passing arguments: [SemanticExpression],
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(!initializers.isEmpty, "The call has no initializers")
        precondition(
            initializers.allSatisfy { initializer in arguments.count == initializer.parameters.count },
            "The initializers do not all have exactly \(arguments.count) parameters"
        )
        return SemanticExpression(
            _kind: .call(toInitializers: initializers.map { initializer in Weak(initializer) }, passing: arguments),
            at: location
        )
    }
    
    @inlinable
    public static func property(
        _ property: SemanticProperty,
        of base: SemanticExpression,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .property(property, of: base),
            at: location
        )
    }
    
    @inlinable
    public static func structurePrimitive(
        _ structure: SemanticStructure,
        propertyValues: [SemanticExpression],
        at location: SourceLocation?
    ) -> SemanticExpression {
        precondition(
            propertyValues.count == structure.properties.count,
            "Expected exactly \(structure.properties.count) values, but got \(propertyValues.count)"
        )
        return SemanticExpression(
            _kind: .structurePrimitive(Weak(structure), propertyValues: propertyValues),
            at: location
        )
    }
    
    @inlinable
    public static func integerPrimitive(
        words: [UInt64],
        bitWidth: BitWidth
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .integerPrimitive(words: words, bitWidth: bitWidth)
        )
    }
    
    @inlinable
    public static func bytePrimitive(
        words: [UInt64],
        bitWidth: BitWidth
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .bytePrimitive(words: words, bitWidth: bitWidth)
        )
    }
    
    @inlinable
    public static func primitiveTruncation(
        of value: SemanticExpression,
        to type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .primitiveTruncation(of: value, to: type),
            at: location
        )
    }
    
    @inlinable
    public static func primitiveBitCast(
        of value: SemanticExpression,
        to type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticExpression {
        SemanticExpression(
            _kind: .primitiveBitCast(of: value, to: type),
            at: location
        )
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
