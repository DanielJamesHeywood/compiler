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
            let externalNames = newValue.filter(\.isExternal).map(\.name)
                + _functions.filter(\.isExternal).map(\.name)
                + _variables.filter(\.isExternal).map(\.name)
            precondition(
                Set(externalNames).count == externalNames.count,
                "The module cannot contain multiple external declarations with the same name"
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
            let externalNames = _constants.filter(\.isExternal).map(\.name)
                + newValue.filter(\.isExternal).map(\.name)
                + _variables.filter(\.isExternal).map(\.name)
            precondition(
                Set(externalNames).count == externalNames.count,
                "The module cannot contain multiple external declarations with the same name"
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
            let externalNames = _constants.filter(\.isExternal).map(\.name)
                + _functions.filter(\.isExternal).map(\.name)
                + newValue.filter(\.isExternal).map(\.name)
            precondition(
                Set(externalNames).count == externalNames.count,
                "The module cannot contain multiple external declarations with the same name"
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
