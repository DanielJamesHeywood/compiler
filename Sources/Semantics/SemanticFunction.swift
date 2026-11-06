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
    internal let _container: SemanticContainer
    
    @usableFromInline
    internal var _body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        in module: SemanticModule,
        at location: SourceLocation?
    ) {
        precondition(
            !isExternal || !module._externalNames.contains(_name),
            "The module cannot contain another external declaration named \"\(_name)\""
        )
        precondition(
            Set(parameters.map(\.name)).count == parameters.count,
            "The parameters do not have unique names"
        )
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.parameters = parameters
        self.returnType = returnType
        self.location = location
        self._container = .module(Weak(module))
    }
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        parameters: [SemanticParameter],
        returnType: SemanticType,
        in structure: SemanticStructure,
        at location: SourceLocation?
    ) {
        precondition(
            accessLevel == .private || structure.accessLevel == .public,
            "The private structure \"\(structure.name)\" cannot contain a public function"
        )
        precondition(
            Set(parameters.map(\.name)).count == parameters.count,
            "The parameters do not have unique names"
        )
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = false
        self.parameters = parameters
        self.returnType = returnType
        self.location = location
        self._container = .structure(Weak(structure))
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
