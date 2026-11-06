import Syntax
import Tokens

public final class SemanticInitializer {
    
    public let accessLevel: AccessLevel
    
    public let parameters: [SemanticParameter]
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal let _container: _Container
    
    @usableFromInline
    internal var _body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(
        _accessLevel: AccessLevel,
        parameters: [SemanticParameter],
        in structure: SemanticStructure,
        at location: SourceLocation?
    ) {
        let labels = parameters.map { $0.label ?? $0.name }
        precondition(
            !structure._initializerLabels.contains(labels),
            "The structure \"\(structure.name)\" contains another initializer with the same labels"
        )
        if case let .module(module) = structure._container {
            precondition(
                !module.object!._compoundNames.contains([structure.name] + labels),
                "The module contains a function named \"\(structure.name)\" with the same labels"
            )
        }
        precondition(
            _accessLevel == .private || structure.accessLevel == .public,
            "The private structure \"\(structure.name)\" cannot contain a public initializer"
        )
        precondition(
            Set(parameters.map(\.name)).count == parameters.count,
            "The parameters do not have unique names"
        )
        self.accessLevel = _accessLevel
        self.parameters = parameters
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
