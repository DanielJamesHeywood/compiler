import Tokens

public struct SyntacticExpression: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case identifier(Identifier)
        case `self`
        case integerLiteral(IntegerLiteral)
        indirect case member(Identifier, of: SyntacticExpression)
        indirect case primitiveTruncation(of: SyntacticExpression, to: SyntacticType)
        indirect case primitiveBitCast(of: SyntacticExpression, to: SyntacticType)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation? = nil) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func identifier(
        _ identifier: Identifier,
        at location: SourceLocation? = nil
    ) -> SyntacticExpression {  SyntacticExpression(_kind: .identifier(identifier), at: location) }
    
    @inlinable
    public static func `self`(
        at location: SourceLocation? = nil
    ) -> SyntacticExpression { SyntacticExpression(_kind: .self, at: location) }
    
    @inlinable
    public static func integerLiteral(
        _ literal: IntegerLiteral,
        at location: SourceLocation? = nil
    ) -> SyntacticExpression { SyntacticExpression(_kind: .integerLiteral(literal), at: location) }
    
    @inlinable
    public static func member(
        _ name: Identifier,
        of base: SyntacticExpression,
        at location: SourceLocation? = nil
    ) -> SyntacticExpression { SyntacticExpression(_kind: .member(name, of: base), at: location) }

    @inlinable
    public static func primitiveTruncation(
        of value: SyntacticExpression,
        to type: SyntacticType
    ) -> SyntacticExpression { SyntacticExpression(_kind: .primitiveTruncation(of: value, to: type)) }

    @inlinable
    public static func primitiveBitCast(
        of value: SyntacticExpression,
        to type: SyntacticType
    ) -> SyntacticExpression { SyntacticExpression(_kind: .primitiveBitCast(of: value, to: type)) }
}
