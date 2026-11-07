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
    internal var _body: [SemanticStatement]?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(
        _ name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        at location: SourceLocation?
    ) {
        precondition(Set(parameters.map(\.name)).count == parameters.count, "The parameters do not have unique names")
        self.name = name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.parameters = parameters
        self.returnType = returnType
        self.location = location
        for parameter in parameters {
            precondition(parameter._container == nil, "The parameter is already in the signature of a function or initializer")
            parameter._container = _Container(self)
        }
    }
    
    @inlinable
    public var body: [SemanticStatement]? {
        get { _body }
        set {
            _body = newValue
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
