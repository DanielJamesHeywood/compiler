@usableFromInline
internal enum _Container: Hashable {
    case module(Weak<SemanticModule>)
    case function(Weak<SemanticFunction>)
    case initializer(Weak<SemanticInitializer>)
    case structure(Weak<SemanticStructure>)
}

extension _Container {
    
    @inlinable
    internal init(_ module: SemanticModule) {
        self = .module(Weak(module))
    }
    
    @inlinable
    internal init(_ function: SemanticFunction) {
        self = .function(Weak(function))
    }
    
    @inlinable
    internal init(_ initializer: SemanticInitializer) {
        self = .initializer(Weak(initializer))
    }
    
    @inlinable
    internal init(_ structure: SemanticStructure) {
        self = .structure(Weak(structure))
    }
    
    @inlinable
    internal var module: SemanticModule? {
        guard case let .module(weakModule) = self else {
            return nil
        }
        guard let module = weakModule.object else {
            preconditionFailure("The module has been deallocated")
        }
        return module
    }
    
    @inlinable
    internal var function: SemanticFunction? {
        guard case let .function(weakFunction) = self else {
            return nil
        }
        guard let function = weakFunction.object else {
            preconditionFailure("The function has been deallocated")
        }
        return function
    }
    
    @inlinable
    internal var initializer: SemanticInitializer? {
        guard case let .initializer(weakInitializer) = self else {
            return nil
        }
        guard let initializer = weakInitializer.object else {
            preconditionFailure("The initializer has been deallocated")
        }
        return initializer
    }
    
    @inlinable
    internal var structure: SemanticStructure? {
        guard case let .structure(weakStructure) = self else {
            return nil
        }
        guard let structure = weakStructure.object else {
            preconditionFailure("The structure has been deallocated")
        }
        return structure
    }
}
