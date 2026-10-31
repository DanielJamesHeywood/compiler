import Tokens

public struct SyntacticArgument: Hashable, Sendable {
    
    public let value: SyntacticExpression
    
    public let label: Identifier?
    
    public let location: SourceLocation
    
    @inlinable
    public init(_ value: SyntacticExpression, label: Identifier?, at location: SourceLocation) {
        self.value = value
        self.label = label
        self.location = location
    }
}
