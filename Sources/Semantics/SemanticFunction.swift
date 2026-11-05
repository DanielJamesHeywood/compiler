import Syntax
import Tokens

public final class SemanticFunction {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let isExternal: Bool
    
    public let parameters: [SemanticParameter]
    
    public let returnType: SemanticType
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool = false,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) {
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.parameters = parameters
        self.returnType = returnType
        self.location = location
    }
    
    @inlinable
    public var body: [SemanticStatement]? {
        get { _body }
        set(newBody) {
            _body = newBody
        }
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
