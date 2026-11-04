import Syntax
import Tokens

public final class SemanticConstant {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let isExternal: Bool
    
    public let type: SemanticType
    
    public let container: SemanticContainer?
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.type = type
        self.container = nil
        self.location = location
    }
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        type: SemanticType,
        in structure: SemanticStructure,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = false
        self.type = type
        self.container = .structure(Weak(structure))
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
