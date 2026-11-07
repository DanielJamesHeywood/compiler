import Syntax
import Tokens

public final class SemanticConstant {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let isExternal: Bool
    
    public let type: SemanticType
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        at location: SourceLocation?
    ) {
        self.name = name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
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
