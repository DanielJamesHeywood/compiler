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
    
    @usableFromInline
    internal var body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.parameters = parameters
        self.returnType = returnType
        self.container = nil
        self.location = location
    }
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel?,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        in container: SemanticContainer,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = false
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
