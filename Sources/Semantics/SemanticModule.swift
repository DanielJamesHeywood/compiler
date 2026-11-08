public final class SemanticModule {
    
    @usableFromInline
    internal var _constants = [] as [SemanticConstant]
    
    @usableFromInline
    internal var _functions = [] as [SemanticFunction]
    
    @usableFromInline
    internal var _structures = [] as [SemanticStructure]
    
    @usableFromInline
    internal var _variables = [] as [SemanticVariable]
    
    @inlinable
    public init() {}
    
    @inlinable
    public var constants: [SemanticConstant] {
        get { _constants }
        set {
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
    public var structures: [SemanticStructure] {
        get { _structures }
        set {
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

extension SemanticModule: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticModule, rhs: SemanticModule) -> Bool { lhs === rhs }
}

extension SemanticModule: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

extension SemanticModule: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        Mirror(
            self,
            children: ["constants": constants, "functions": functions, "structures": structures, "variables": variables],
            displayStyle: .class
        )
    }
}
