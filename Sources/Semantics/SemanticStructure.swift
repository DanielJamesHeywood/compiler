import Syntax
import Tokens

public final class SemanticStructure {
    
    public let name: Identifier
    
    public let accessLevel: AccessLevel
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _constants = [] as [SemanticConstant]
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _initializers = [] as [SemanticInitializer]
    
    @usableFromInline
    internal var _structures = [] as [SemanticStructure]
    
    @usableFromInline
    internal var _variables = [] as [SemanticVariable]
    
    @usableFromInline
    internal var _container: _Container?
    
    @inlinable
    public init(_ name: Identifier, accessLevel: AccessLevel, at location: SourceLocation?) {
        self.name = name
        self.accessLevel = accessLevel
        self.location = location
    }
    
    @inlinable
    public var constants: [SemanticConstant] {
        get { _constants }
        set {
            precondition(
                accessLevel == .public || newValue.allSatisfy { $0.accessLevel == .private },
                "The private structure \"\(name)\" cannot contain a public constant"
            )
            for constant in _constants {
                constant._container = nil
            }
            for constant in newValue {
                precondition(constant._container == nil, "The constant is already in a module or structure")
                constant._container = _Container(self)
            }
            _constants = newValue
        }
    }
    
    @inlinable
    public var functions: [SemanticFunction] {
        get { _functions }
        set {
            precondition(
                accessLevel == .public || newValue.allSatisfy { $0.accessLevel == .private },
                "The private structure \"\(name)\" cannot contain a public function"
            )
            for function in _functions {
                function._container = nil
            }
            for function in newValue {
                precondition(function._container == nil, "The function is already in a module or structure")
                function._container = _Container(self)
            }
            _functions = newValue
        }
    }
    
    @inlinable
    public var initializers: [SemanticInitializer] {
        get { _initializers }
        set {
            precondition(
                accessLevel == .public || newValue.allSatisfy { $0.accessLevel == .private },
                "The private structure \"\(name)\" cannot contain a public initializer"
            )
            for initializer in _initializers {
                initializer._container = nil
            }
            for initializer in newValue {
                precondition(initializer._container == nil, "The initializer is already in a structure")
                initializer._container = _Container(self)
            }
            _initializers = newValue
        }
    }
    
    @inlinable
    public var structures: [SemanticStructure] {
        get { _structures }
        set {
            precondition(
                accessLevel == .public || newValue.allSatisfy { $0.accessLevel == .private },
                "The private structure \"\(name)\" cannot contain a public structure"
            )
            for structure in _structures {
                structure._container = nil
            }
            for structure in newValue {
                precondition(structure._container == nil, "The structure is already in a module or structure")
                structure._container = _Container(self)
            }
            _structures = newValue
        }
    }
    
    @inlinable
    public var variables: [SemanticVariable] {
        get { _variables }
        set {
            precondition(
                accessLevel == .public || newValue.allSatisfy { $0.accessLevel == .private },
                "The private structure \"\(name)\" cannot contain a public variable"
            )
            for variable in _variables {
                variable._container = nil
            }
            for variable in newValue {
                precondition(variable._container == nil, "The variable is already in a module or structure")
                variable._container = _Container(self)
            }
            _variables = newValue
        }
    }
}

extension SemanticStructure: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticStructure, rhs: SemanticStructure) -> Bool { lhs === rhs }
}

extension SemanticStructure: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
