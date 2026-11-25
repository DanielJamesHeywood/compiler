import Tokens

public struct SyntacticArgument: Sendable {
    
    public let value: SyntacticExpression
    
    public let label: Identifier?
    
    public let location: SourceLocation?
    
    @inlinable
    public init(_ value: SyntacticExpression, label: Identifier? = nil, at location: SourceLocation? = nil) {
        self.value = value
        self.label = label
        self.location = location
    }
}

extension SyntacticArgument: Equatable {
    
    @inlinable
    public static func == (lhs: SyntacticArgument, rhs: SyntacticArgument) -> Bool {
        lhs.value == rhs.value && lhs.label == rhs.label
    }
}

extension SyntacticArgument: Hashable {
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(label)
    }
}
