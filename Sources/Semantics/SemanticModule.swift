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
