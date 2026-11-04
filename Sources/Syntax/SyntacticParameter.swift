import Tokens

public struct SyntacticParameter: Hashable, Sendable {
    
    public let name: Identifier
    
    public let label: Identifier?
    
    public let type: SyntacticType
    
    public let location: SourceLocation?
    
    @inlinable
    public init(_ name: Identifier, label: Identifier? = nil, type: SyntacticType, at location: SourceLocation? = nil) {
        self.name = name
        self.label = label
        self.type = type
        self.location = location
    }
}
