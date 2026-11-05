import OrderedCollections
import Syntax
import Tokens

public final class SemanticStructure {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _constants = [] as OrderedSet<SemanticConstant>
    
    @usableFromInline
    internal var _functions = [] as OrderedSet<SemanticFunction>
    
    @usableFromInline
    internal var _initializers = [] as OrderedSet<SemanticInitializer>
    
    @usableFromInline
    internal var _structures = [] as OrderedSet<SemanticStructure>
    
    @usableFromInline
    internal var _variables = [] as OrderedSet<SemanticVariable>
    
    @inlinable
    internal init(_name: Identifier, accessLevel: AccessLevel, at location: SourceLocation?) {
        self.name = _name
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public var constants: OrderedSet<SemanticConstant> { _constants }
    
    @inlinable
    public var functions: OrderedSet<SemanticFunction> { _functions }
    
    @inlinable
    public var initializers: OrderedSet<SemanticInitializer> { _initializers }
    
    @inlinable
    public var structures: OrderedSet<SemanticStructure> { _structures }
    
    @inlinable
    public var variables: OrderedSet<SemanticVariable> { _variables }
    
    @inlinable
    public func appendConstant(
        _ name: Identifier,
        accessLevel: AccessLevel,
        type: SemanticType,
        at location: SourceLocation?
    ) {
        _constants.append(
            SemanticConstant(
                _name: name,
                accessLevel: accessLevel,
                type: type,
                at: location
            )
        )
    }
    
    @inlinable
    public func appendFunction(
        _ name: Identifier,
        accessLevel: AccessLevel,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) {
        _functions.append(
            SemanticFunction(
                _name: name,
                accessLevel: accessLevel,
                parameters: parameters,
                returnType: returnType,
                at: location
            )
        )
    }
    
    @inlinable
    public func appendInitializer(
        accessLevel: AccessLevel,
        parameters: [SemanticParameter],
        at location: SourceLocation?
    ) {
        _initializers.append(
            SemanticInitializer(
                _accessLevel: accessLevel,
                parameters: parameters,
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
        type: SemanticType,
        at location: SourceLocation?
    ) {
        _variables.append(
            SemanticVariable(
                _name: name,
                accessLevel: accessLevel,
                type: type,
                at: location
            )
        )
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
