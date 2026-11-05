import Syntax
import Tokens

public final class SemanticConstant {
    
    public let name: Identifier
    
    public let isExternal: Bool
    
    public let type: SemanticType
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_name: Identifier, isExternal: Bool, type: SemanticType, at location: SourceLocation?) {
        self.name = _name
        self.isExternal = isExternal
        self.type = type
        self.location = location
    }
    
    @inlinable
    internal init(_name: Identifier, type: SemanticType, at location: SourceLocation?) {
        self.name = _name
        self.isExternal = false
        self.type = type
        self.location = location
    }
}

extension SemanticConstant: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticConstant, rhs: SemanticConstant) -> Bool { lhs === rhs }
}

extension SemanticConstant: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
