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
