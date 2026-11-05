import OrderedCollections
import Syntax
import Tokens

public final class SemanticModule {
    
    public var constants = [] as OrderedSet<SemanticConstant>
    
    public var variables = [] as OrderedSet<SemanticVariable>
    
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
