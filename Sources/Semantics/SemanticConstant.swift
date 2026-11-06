import Syntax
import Tokens

public final class SemanticConstant {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let isExternal: Bool
    
    public let type: SemanticType
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal let _container: _Container
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        isExternal: Bool,
        type: SemanticType,
        in module: SemanticModule,
        at location: SourceLocation?
    ) {
        precondition(
            !module._unlabelledNames.contains(_name),
            "The module contains another declaration named \"\(_name)\""
        )
        precondition(
            !isExternal || !module._externalNames.contains(_name),
            "The module contains another external declaration named \"\(_name)\""
        )
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = isExternal
        self.type = type
        self.location = location
        self._container = .module(Weak(module))
    }
    
    @inlinable
    internal init(
        _name: Identifier,
        accessLevel: AccessLevel,
        type: SemanticType,
        in structure: SemanticStructure,
        at location: SourceLocation?
    ) {
        precondition(
            !structure._unlabelledNames.contains(_name),
            "The structure \"\(structure.name)\" contains another declaration named \"\(_name)\""
        )
        precondition(
            accessLevel == .private || structure.accessLevel == .public,
            "The private structure \"\(structure.name)\" cannot contain a public constant"
        )
        self.name = _name
        self.accessLevel = accessLevel
        self.isExternal = false
        self.type = type
        self.location = location
        self._container = .structure(Weak(structure))
    }
}

extension SemanticConstant: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticConstant, rhs: SemanticConstant) -> Bool { lhs === rhs }
}

extension SemanticConstant: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
