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
    internal let _container: _Container
    
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
        let labels = parameters.map { $0.label ?? $0.name }
        precondition(
            !module._compoundNames.contains([_name] + labels),
            "The module contains another declaration with the same compound name"
        )
        precondition(
            !labels.allSatisfy { $0 == "_" } ||
            !module._unlabelledNames.contains(_name) ||
            module._unlabelledFunctionNames.contains(_name),
            "The module contains another declaration named \"\(_name)\""
        )
        precondition(
            !isExternal || !module._externalNames.contains(_name),
            "The module contains another external declaration named \"\(_name)\""
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
        let labels = parameters.map { $0.label ?? $0.name }
        precondition(
            !structure._compoundNames.contains([_name] + labels),
            "The structure \"\(structure.name)\" contains another function named \"\(_name)\" with the same labels"
        )
        precondition(
            !labels.allSatisfy { $0 == "_" } ||
            !structure._unlabelledNames.contains(_name) ||
            structure._unlabelledFunctionNames.contains(_name),
            "The structure \"\(structure.name)\" contains another declaration named \"\(_name)\""
        )
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
