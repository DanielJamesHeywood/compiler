import Syntax
import Tokens

public final class SemanticStructureDeclaration {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation?
    
    @inlinable
    public init(_ name: Identifier, accessLevel: AccessLevel?, at location: SourceLocation?) {
        self.name = name
        self.accessLevel = accessLevel
        self.location = location
    }
}

extension SemanticStructureDeclaration: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticStructureDeclaration, rhs: SemanticStructureDeclaration) -> Bool { lhs === rhs }
}

extension SemanticStructureDeclaration: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
