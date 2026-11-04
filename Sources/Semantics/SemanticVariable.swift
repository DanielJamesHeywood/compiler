import Syntax
import Tokens

public final class SemanticVariable {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel?
    
    public let isExternal: Bool
    
    public let type: SemanticType
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool = false,
        type: SemanticType,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.type = type
        self.location = location
    }
}

extension SemanticVariable: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticVariable, rhs: SemanticVariable) -> Bool { lhs === rhs }
}

extension SemanticVariable: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
