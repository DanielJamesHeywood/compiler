import Syntax
import Tokens

public final class SemanticInitializer {
    
    public let accessLevel: AccessLevel?
    
    public let parameters: [SemanticParameter]
    
    public let container: SemanticContainer
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(
        _accessLevel: AccessLevel?,
        parameters: [SemanticParameter],
        in container: SemanticContainer,
        at location: SourceLocation?
    ) {
        self.accessLevel = _accessLevel
        self.parameters = parameters
        self.container = container
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
