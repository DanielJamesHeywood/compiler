import Syntax
import Tokens

public final class SemanticFunction {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel?
    
    public let isExternal: Bool
    
    public let parameters: [SemanticParameter]
    
    public let returnType: SemanticType
    
    public let container: SemanticContainer?
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel?,
        isExternal: Bool = false,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        in container: SemanticContainer? = nil,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.parameters = parameters
        self.returnType = returnType
        self.container = container
        self.location = location
    }
}

extension SemanticFunction: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticFunction, rhs: SemanticFunction) -> Bool { lhs === rhs }
}

extension SemanticFunction: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
