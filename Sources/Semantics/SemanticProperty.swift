import Tokens

public enum SemanticProperty: Hashable {
    case constant(SemanticConstant)
    case variable(SemanticVariable)
}

extension SemanticProperty {
    
    @inlinable
    public var name: Identifier {
        switch self {
        case let .constant(constant):
            constant.name
        case let .variable(variable):
            variable.name
        }
    }
    
    @inlinable
    public var type: SemanticType {
        switch self {
        case let .constant(constant):
            constant.type
        case let .variable(variable):
            variable.type
        }
    }
    
    @inlinable
    public var containingStructure: SemanticStructure {
        guard case let .structure(weakStructure) = _container else {
            preconditionFailure("The property \"\(name)\" is not a member of a structure")
        }
        guard let structure = weakStructure.object else {
            preconditionFailure("The structure has been deallocated")
        }
        return structure
    }
    
    @inlinable
    internal var _container: _Container? {
        get {
            switch self {
            case let .constant(constant):
                constant._container
            case let .variable(variable):
                variable._container
            }
        }
        nonmutating set {
            switch self {
            case let .constant(constant):
                constant._container = newValue
            case let .variable(variable):
                variable._container = newValue
            }
        }
    }
}
