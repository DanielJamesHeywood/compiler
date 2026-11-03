import Syntax
import Tokens

public final class SemanticStructure {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel?
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _initializers = [] as [SemanticInitializer]
    
    @inlinable
    public init(_ name: Identifier, accessLevel: AccessLevel?, at location: SourceLocation?) {
        self.name = name
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public func appendInitializer(accessLevel: AccessLevel?, at location: SourceLocation?) {
        _initializers.append(SemanticInitializer(_of: self, accessLevel: accessLevel, at: location))
    }
}

extension SemanticStructure: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticStructure, rhs: SemanticStructure) -> Bool { lhs === rhs }
}

extension SemanticStructure: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
