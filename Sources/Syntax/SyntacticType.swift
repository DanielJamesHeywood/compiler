import Tokens

public struct SyntacticType: Hashable, Sendable {
    
    public enum Kind: Hashable, Sendable {
        case identifier(Identifier)
    }
    
    public let kind: Kind
    
    public let location: SourceLocation?
    
    @inlinable
    internal init(_kind: Kind, at location: SourceLocation?) {
        self.kind = _kind
        self.location = location
    }
    
    @inlinable
    public static func identifier(_ identifier: Identifier, at location: SourceLocation? = nil) -> SyntacticType {
        SyntacticType(_kind: .identifier(identifier), at: location)
    }
}
