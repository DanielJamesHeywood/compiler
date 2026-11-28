public enum SemanticAnalysisError: Hashable, Error {
    case invalidRedeclaration
}

extension SemanticAnalysisError: CustomStringConvertible {
    
    @inlinable
    public var description: String {
        switch self {
        case .invalidRedeclaration:
            "Invalid redeclaration"
        }
    }
}


extension SemanticAnalysisError: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        let caseDescription = switch self {
        case .invalidRedeclaration:
            "invalidRedeclaration"
        }
        return "SemanticAnalysis.SemanticAnalysisError.\(caseDescription)"
    }
}
