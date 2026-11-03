import Syntax

public struct SemanticType: Hashable {
    
    public enum Kind: Hashable {}
    
    public let kind: Kind
    
    @inlinable
    internal init(_kind: Kind) {
        self.kind = _kind
    }
}
