import Tokens

public struct SyntacticExpression: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case identifier(Identifier)
        case `self`
        case integerLiteral(IntegerLiteral)
        indirect case call(to: SyntacticExpression, passing: [SyntacticArgument])
        indirect case member(Identifier, of: SyntacticExpression)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func identifier(
        _ identifier: Identifier,
        at location: SourceLocation
    ) -> SyntacticExpression {
        SyntacticExpression(_kind: .identifier(identifier), at: location)
    }
    
    @inlinable
    public static func `self`(
        at location: SourceLocation
    ) -> SyntacticExpression { SyntacticExpression(_kind: .self, at: location) }
    
    @inlinable
    public static func integerLiteral(
        _ literal: IntegerLiteral,
        at location: SourceLocation
    ) -> SyntacticExpression { SyntacticExpression(_kind: .integerLiteral(literal), at: location) }
    
    @inlinable
    public static func call(
        to function: SyntacticExpression,
        passing arguments: [SyntacticArgument],
        at location: SourceLocation
    ) -> SyntacticExpression { SyntacticExpression(_kind: .call(to: function, passing: arguments), at: location) }
    
    @inlinable
    public static func member(
        _ name: Identifier,
        of base: SyntacticExpression,
        at location: SourceLocation
    ) -> SyntacticExpression { SyntacticExpression(_kind: .member(name, of: base), at: location) }
}
