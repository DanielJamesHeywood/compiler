import OrderedCollections
import Syntax
import Tokens

public final class SemanticModule {
    
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
    public init() {}
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
