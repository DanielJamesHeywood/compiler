import Syntax
import Tokens

public final class SemanticInitializerDeclaration {
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation?
    
    @inlinable
    public init(accessLevel: AccessLevel?, at location: SourceLocation?) {
        self.accessLevel = accessLevel
        self.location = location
    }
}

extension SemanticInitializerDeclaration: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticInitializerDeclaration, rhs: SemanticInitializerDeclaration) -> Bool {
        lhs === rhs
    }
}

extension SemanticInitializerDeclaration: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
