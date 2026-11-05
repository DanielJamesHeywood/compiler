import OrderedCollections
import Syntax
import Tokens

public final class SemanticModule {
    
    @usableFromInline
    internal var _constants = [] as OrderedSet<SemanticConstant>
    
    @usableFromInline
    internal var _functions = [] as OrderedSet<SemanticFunction>
    
    @usableFromInline
    internal var _structures = [] as OrderedSet<SemanticStructure>
    
    @usableFromInline
    internal var _variables = [] as OrderedSet<SemanticVariable>
    
    @inlinable
    public init() {}
    
    @inlinable
    public var constants: OrderedSet<SemanticConstant> { _constants }
    
    @inlinable
    public var functions: OrderedSet<SemanticFunction> { _functions }
    
    @inlinable
    public var structures: OrderedSet<SemanticStructure> { _structures }
    
    @inlinable
    public var variables: OrderedSet<SemanticVariable> { _variables }
    
    @inlinable
    public func appendConstant(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) {
        _constants.append(
            SemanticConstant(
                _name: name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                type: type,
                at: location
            )
        )
    }
    
    @inlinable
    public func appendFunction(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) {
        _functions.append(
            SemanticFunction(
                _name: name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                parameters: parameters,
                returnType: returnType,
                at: location
            )
        )
    }
    
    @inlinable
    public func appendStructure(
        _ name: Identifier,
        accessLevel: AccessLevel,
        at location: SourceLocation?
    ) {
        _structures.append(
            SemanticStructure(
                _name: name,
                accessLevel: accessLevel,
                at: location
            )
        )
    }
    
    @inlinable
    public func appendVariable(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) {
        _variables.append(
            SemanticVariable(
                _name: name,
                accessLevel: accessLevel,
                isExternal: isExternal,
                type: type,
                at: location
            )
        )
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
