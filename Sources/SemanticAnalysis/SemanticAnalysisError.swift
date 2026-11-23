public struct SemanticAnalysisError: Hashable, Error {}

extension SemanticAnalysisError: CustomStringConvertible {
    
    @inlinable
    public var description: String { "" }
}

extension SemanticAnalysisError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String { "SemanticAnalysis.SemanticAnalysisError()" }
}
