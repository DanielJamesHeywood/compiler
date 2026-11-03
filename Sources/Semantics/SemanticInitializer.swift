import Syntax
import Tokens

public final class SemanticInitializer {
    
    public weak let structure: SemanticStructure?
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_of structure: SemanticStructure, accessLevel: AccessLevel?, at location: SourceLocation?) {
        self.structure = structure
        self.accessLevel = accessLevel
        self.location = location
    }
}

extension SemanticInitializer: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticInitializer, rhs: SemanticInitializer) -> Bool { lhs === rhs }
}

extension SemanticInitializer: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
