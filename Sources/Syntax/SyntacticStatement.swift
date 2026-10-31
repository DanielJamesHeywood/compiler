import Tokens

public struct SyntacticStatement: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case `return`(of: SyntacticExpression?)
        case assignment(of: SyntacticExpression, to: SyntacticExpression)
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
        of value: SyntacticExpression? = nil,
        at location: SourceLocation? = nil
    ) -> SyntacticStatement { SyntacticStatement(_kind: .return(of: value), at: location) }
    
    @inlinable
    public static func assignment(
        of source: SyntacticExpression,
        to destination: SyntacticExpression,
        at location: SourceLocation? = nil
    ) -> SyntacticStatement { SyntacticStatement(_kind: .assignment(of: source, to: destination), at: location) }
}
