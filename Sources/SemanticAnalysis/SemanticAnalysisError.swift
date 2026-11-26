public enum SemanticAnalysisError: Hashable, Error {}

extension SemanticAnalysisError: CustomStringConvertible {
    
    @inlinable
    public var description: String { switch self {} }
}


extension SemanticAnalysisError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String { switch self {} }
}
