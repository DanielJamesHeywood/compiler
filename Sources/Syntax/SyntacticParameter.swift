import Tokens

public struct SyntacticParameter: Sendable {
    
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

extension SyntacticParameter: Equatable {
    
    @inlinable
    public static func == (lhs: SyntacticParameter, rhs: SyntacticParameter) -> Bool {
        lhs.name == rhs.name && lhs.label == rhs.label && lhs.type == rhs.type
    }
}

extension SyntacticParameter: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(label)
        hasher.combine(type)
    }
}
