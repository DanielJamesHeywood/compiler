@usableFromInline
internal enum _Container: Hashable {
    case module(Weak<SemanticModule>)
    case structure(Weak<SemanticStructure>)
    case initializer(Weak<SemanticInitializer>)
    case function(Weak<SemanticFunction>)
}

extension _Container {
    
    @inlinable
    internal init(_ module: SemanticModule) {
        self = .module(Weak(module))
    }
    
    @inlinable
    internal init(_ structure: SemanticStructure) {
        self = .structure(Weak(structure))
    }
    
    @inlinable
    internal init(_ initializer: SemanticInitializer) {
        self = .initializer(Weak(initializer))
    }
    
    @inlinable
    internal init(_ function: SemanticFunction) {
        self = .function(Weak(function))
    }
}
