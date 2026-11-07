import Syntax
import Tokens

public final class SemanticInitializer {
    
    public let accessLevel: AccessLevel
    
    public let parameters: [SemanticParameter]
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _body: [SemanticStatement]?
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(accessLevel: AccessLevel, parameters: [SemanticParameter], at location: SourceLocation?) {
        precondition(Set(parameters.map(\.name)).count == parameters.count, "The parameters do not have unique names")
        self.accessLevel = accessLevel
        self.parameters = parameters
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
