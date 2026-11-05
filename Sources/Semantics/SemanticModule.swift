import Syntax
import Tokens

public final class SemanticModule {
    
    @usableFromInline
    internal var _constants = [] as [SemanticConstant]
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _structures = [] as [SemanticStructure]
    
    @usableFromInline
    internal var _variables = [] as [SemanticVariable]
    
    @inlinable
    public init() {}
    
    @inlinable
    public var constants: [SemanticConstant] { _constants }
    
    @inlinable
    public var functions: [SemanticFunction] { _functions }
    
    @inlinable
    public var structures: [SemanticStructure] { _structures }
    
    @inlinable
    public var variables: [SemanticVariable] { _variables }
    
    @inlinable
    public func appendConstant(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticConstant {
        let constant = SemanticConstant(
            _name: name,
            accessLevel: accessLevel,
            isExternal: isExternal,
            type: type,
            at: location
        )
        _constants.append(constant)
        return constant
    }
    
    @inlinable
    public func appendFunction(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) -> SemanticFunction {
        precondition(Set(parameters.map(\.name)).count == parameters.count, "The parameters do not have unique names")
        let function = SemanticFunction(
            _name: name,
            accessLevel: accessLevel,
            isExternal: isExternal,
            parameters: parameters,
            returnType: returnType,
            at: location
        )
        _functions.append(function)
        return function
    }
    
    @inlinable
    public func appendStructure(
        _ name: Identifier,
        accessLevel: AccessLevel,
        at location: SourceLocation?
    ) -> SemanticStructure {
        let structure = SemanticStructure(
            _name: name,
            accessLevel: accessLevel,
            at: location
        )
        _structures.append(structure)
        return structure
    }
    
    @inlinable
    public func appendVariable(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) -> SemanticVariable {
        let variable = SemanticVariable(
            _name: name,
            accessLevel: accessLevel,
            isExternal: isExternal,
            type: type,
            at: location
        )
        _variables.append(variable)
        return variable
    }
}

extension SemanticModule: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticModule, rhs: SemanticModule) -> Bool { lhs === rhs }
}

extension SemanticModule: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
