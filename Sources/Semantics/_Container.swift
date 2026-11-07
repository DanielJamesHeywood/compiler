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
}
