import Syntax
import Tokens

public final class SemanticInitializer {
    
    public let accessLevel: AccessLevel
    
    public let parameters: [SemanticParameter]
    
    public let location: SourceLocation?
    
    @usableFromInline
    internal var _body = nil as [SemanticStatement]?
    
    @inlinable
    internal init(_accessLevel: AccessLevel, parameters: [SemanticParameter], at location: SourceLocation?) {
        self.accessLevel = _accessLevel
        self.parameters = parameters
        self.location = location
    }
    
    @inlinable
    public var body: [SemanticStatement]? {
        get { _body }
        set(newBody) {
            _body = newBody
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
