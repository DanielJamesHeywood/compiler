import Tokens

public struct SemanticStatement: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case `return`(of: SemanticExpression?)
        case assignment(of: SemanticExpression, to: SemanticExpression)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation?) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func `return`(
        of value: SemanticExpression?,
        at location: SourceLocation?
    ) -> SemanticStatement { SemanticStatement(_kind: .return(of: value), at: location) }
    
    @inlinable
    public static func assignment(
        of source: SemanticExpression,
        to destination: SemanticExpression,
        at location: SourceLocation?
    ) -> SemanticStatement { SemanticStatement(_kind: .assignment(of: source, to: destination), at: location) }
}
