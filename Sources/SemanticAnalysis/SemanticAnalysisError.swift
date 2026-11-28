import Tokens

public enum SemanticAnalysisError: Hashable, Error {
    case invalidRedeclaration(of: Identifier)
}

extension SemanticAnalysisError: CustomStringConvertible {
    
    @inlinable
    public var description: String {
        switch self {
        case let .invalidRedeclaration(of: name):
            "Invalid redeclaration of '\(name)'"
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
