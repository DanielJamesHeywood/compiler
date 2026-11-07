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
                "A public constant cannot be a member of a private structure"
            )
            precondition(
                newValue.allSatisfy { !$0.isExternal },
                "An external constant cannot be a member of a structure"
            )
            for constant in _constants {
                constant._container = nil
            }
            for constant in newValue {
                precondition(constant._container == nil, "A constant is already declared in a module or structure")
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
                "A public function cannot be a member of a private structure"
            )
            precondition(
                newValue.allSatisfy { !$0.isExternal },
                "An external function cannot be a member of a structure"
            )
            for function in _functions {
                function._container = nil
            }
            for function in newValue {
                precondition(function._container == nil, "A function is already declared in a module or structure")
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
                "A public initializer cannot be a member of a private structure"
            )
            for initializer in _initializers {
                initializer._container = nil
            }
            for initializer in newValue {
                precondition(initializer._container == nil, "An initializer is already declared in a structure")
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
                Set(newValue.map(\.name)).count == newValue.count,
                "The structures do not have unique names"
            )
            precondition(
                accessLevel == .public || newValue.allSatisfy { $0.accessLevel == .private },
                "A public structure cannot be a member of a private structure"
            )
            for structure in _structures {
                structure._container = nil
            }
            for structure in newValue {
                precondition(structure._container == nil, "A structure is already declared in a module or structure")
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
                "A public variable cannot be a member of a private structure"
            )
            precondition(
                newValue.allSatisfy { !$0.isExternal },
                "An external variable cannot be a member of a structure"
            )
            for variable in _variables {
                variable._container = nil
            }
            for variable in newValue {
                precondition(variable._container == nil, "A variable is already declared in a module or structure")
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
