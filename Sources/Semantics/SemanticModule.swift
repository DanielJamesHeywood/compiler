import Syntax
import Tokens

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
    public var structures: [SemanticStructure] {
        get { _structures }
        set {
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
