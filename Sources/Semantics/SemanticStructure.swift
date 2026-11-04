import Syntax
import Tokens

public final class SemanticStructure {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _constants = [] as [SemanticConstant]
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _initializers = [] as [SemanticInitializer]
    
    @usableFromInline
    internal var _structures = [] as [SemanticStructure]
    
    @usableFromInline
    internal var _variables = [] as [SemanticVariable]
    
    @inlinable
    public init(_ name: Identifier, accessLevel: AccessLevel?, at location: SourceLocation?) {
        self.name = name
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public func appendConstant(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticConstant {
        let constant = SemanticConstant(name, accessLevel: accessLevel, isExternal: isExternal, type: type, at: location)
        _constants.append(constant)
        return constant
    }
    
    @inlinable
    public func appendInitializer(
        accessLevel: AccessLevel?,
        parameters: [SemanticParameter],
        at location: SourceLocation?
    ) -> SemanticInitializer {
        let initializer = SemanticInitializer(_of: self, accessLevel: accessLevel, parameters: parameters, at: location)
        _initializers.append(initializer)
        return initializer
    }
    
    @inlinable
    public func appendStructure(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        at location: SourceLocation?
    ) -> SemanticStructure {
        let structure = SemanticStructure(name, accessLevel: accessLevel, at: location)
        _structures.append(structure)
        return structure
    }
    
    @inlinable
    public func appendVariable(
        _ name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticVariable {
        let variable = SemanticVariable(name, accessLevel: accessLevel, isExternal: isExternal, type: type, at: location)
        _variables.append(variable)
        return variable
    }
}

extension SemanticStructure: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticStructure, rhs: SemanticStructure) -> Bool { lhs === rhs }
}

extension SemanticStructure: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
