import Syntax
import Tokens

public final class SemanticInitializer {
    
    public let parameters: [SemanticParameter]
    
    public let container: SemanticContainer
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(_parameters: [SemanticParameter], in structure: SemanticStructure, at location: SourceLocation?) {
        self.parameters = _parameters
        self.container = .structure(Weak(structure))
        self.location = location
    }
    
    @inlinable
    public var body: [SemanticStatement]? {
        get { _body }
        set {
            _body = newValue
        }
    }
}

extension SemanticInitializer: Equatable {
    
    @inlinable
    public static func == (lhs: SemanticInitializer, rhs: SemanticInitializer) -> Bool { lhs === rhs }
}

extension SemanticInitializer: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
